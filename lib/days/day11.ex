defmodule Aoc.Day11 do
  @example """
  125 17
  """
  @example_part1 55_312
  @example_part2 65_601_038_650_482

  use Aoc.Utils.Test

  defp blink([_], 0), do: 1
  defp blink([0], steps), do: blink([1], steps - 1)

  defp blink([stone], steps) do
    case lookup_memo(stone, steps) do
      {:ok, result} -> result
      :not_found -> calculate_and_memo(stone, steps)
    end
  end

  defp blink([head | tail], steps), do: blink([head], steps) + blink(tail, steps)

  defp lookup_memo(stone, steps) do
    case :ets.lookup(:stone_memo, {stone, steps}) do
      [{_, result}] -> {:ok, result}
      [] -> :not_found
    end
  end

  defp calculate_and_memo(stone, steps) do
    calculate_blink(stone, steps, Integer.digits(stone))
    |> tap(&:ets.insert(:stone_memo, {{stone, steps}, &1}))
  end

  defp calculate_blink(stone, steps, digits) when rem(length(digits), 2) != 0, do: blink([stone * 2024], steps - 1)

  defp calculate_blink(_, steps, digits) do
    Enum.split(digits, div(length(digits), 2))
    |> then(fn {left, right} ->
      blink([Integer.undigits(left)], steps - 1) +
        blink([Integer.undigits(right)], steps - 1)
    end)
  end

  def parse_input(input) do
    case :ets.whereis(:stone_memo) do
      :undefined -> :ets.new(:stone_memo, [:set, :protected, :named_table])
      _ -> :ok
    end

    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def solution_part1(input) do
    input
    |> parse_input()
    |> blink(25)
  end

  def solution_part2(input) do
    input
    |> parse_input()
    |> blink(75)
  end
end

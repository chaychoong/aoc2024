defmodule Aoc.Day2 do
  @example """
  7 6 4 2 1
  7 6 4 2 4
  3 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  1 3 6 7 4
  4 3 6 7 9
  """
  @example_part1 2
  @example_part2 8

  use Aoc.Utils.Test

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Stream.map(&String.split/1)
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  defp is_safe_desc?([head | tail = [next | _]]) when (head - next) in 1..3, do: is_safe_desc?(tail)
  defp is_safe_desc?([_]), do: 1
  defp is_safe_desc?(_), do: 0

  defp is_safe?(list = [head | [next | _]]) when head > next, do: is_safe_desc?(list)
  defp is_safe?(list = [head | [next | _]]) when head < next, do: is_safe_desc?(Enum.reverse(list))
  defp is_safe?(_), do: 0

  def solution_part1(input) do
    input
    |> parse_input()
    |> Stream.map(&is_safe?/1)
    |> Enum.sum()
  end

  def check_list_with_deletions(list) do
    list
    |> Stream.with_index()
    |> Stream.map(fn {_, i} -> is_safe?(List.delete_at(list, i)) end)
    |> Enum.sum()
    |> then(&if(&1 > 0, do: 1, else: 0))
  end

  def solution_part2(input) do
    input
    |> parse_input()
    |> Stream.map(&check_list_with_deletions/1)
    |> Enum.sum()
  end
end

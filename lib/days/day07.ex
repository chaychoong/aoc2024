defmodule Aoc.Day7 do
  @example """
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """
  @example_part1 3749
  @example_part2 11387

  use Aoc.Utils.Test

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      [id_str, numbers_str] = String.split(row, ":", parts: 2)

      {
        String.to_integer(id_str),
        numbers_str
        |> String.split()
        |> Enum.map(&String.to_integer/1)
      }
    end)
  end

  def do_op([last], remainder, _), do: remainder == last

  def do_op(ops_list, remainder, mode = :has_concat) do
    [:div, :subtract, :leftshift]
    |> Enum.any?(&do_op(ops_list, remainder, mode, &1))
  end

  def do_op(ops_list, remainder, mode) do
    [:div, :subtract]
    |> Enum.any?(&do_op(ops_list, remainder, mode, &1))
  end

  def do_op([head | tail], remainder, mode, :leftshift) do
    divisor = head |> Integer.digits() |> length() |> then(&Integer.pow(10, &1))

    case rem(remainder, divisor) do
      ^head -> do_op(tail, div(remainder, divisor), mode)
      _ -> false
    end
  end

  def do_op([head | _], remainder, _, :subtract) when remainder < head, do: false
  def do_op([head | tail], remainder, mode, :subtract), do: do_op(tail, remainder - head, mode)

  def do_op([head | _], remainder, _, :div) when rem(remainder, head) != 0, do: false
  def do_op([head | tail], remainder, mode, :div), do: do_op(tail, div(remainder, head), mode)

  def solution_part1(input) do
    input
    |> parse_input()
    |> Enum.reduce(0, fn {result, ops}, acc ->
      if do_op(Enum.reverse(ops), result, :normal), do: acc + result, else: acc
    end)
  end

  def solution_part2(input) do
    input
    |> parse_input()
    |> Enum.reduce(0, fn {result, ops}, acc ->
      if do_op(Enum.reverse(ops), result, :has_concat), do: acc + result, else: acc
    end)
  end
end

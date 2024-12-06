defmodule Aoc.Day1 do
  @example """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """
  @example_part1 11
  @example_part2 31

  use Aoc.Utils.Test

  def parse_input(input) do
    input
    |> String.split()
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(2)
    |> Enum.zip_with(& &1)
  end

  def solution_part1(input) do
    input
    |> parse_input()
    |> Stream.map(&Enum.sort/1)
    |> Stream.zip_with(& &1)
    |> Stream.map(fn [a, b] -> abs(b - a) end)
    |> Enum.sum()
  end

  def solution_part2(input) do
    input
    |> parse_input()
    |> then(fn [left, right] ->
      right_frequencies = Enum.frequencies(right)
      Enum.reduce(left, 0, &(&1 * Map.get(right_frequencies, &1, 0) + &2))
    end)
  end
end

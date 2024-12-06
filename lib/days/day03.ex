defmodule Aoc.Day3 do
  @example """
  xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
  """
  @example_part1 161
  @example_part2 48

  use Aoc.Utils.Test

  @pattern_mul_r ~C"mul\((\d+),(\d+)\)"
  @pattern_do_c "do()"
  @pattern_do_r Regex.escape(@pattern_do_c)
  @pattern_dont_c "don't()"
  @pattern_dont_r Regex.escape(@pattern_dont_c)

  defp parse_input(input, pattern) do
    Regex.scan(pattern, input)
  end

  defp mul_str(a, b), do: String.to_integer(a) * String.to_integer(b)

  def solution_part1(input) do
    input
    |> parse_input(~r/#{@pattern_mul_r}/)
    |> Enum.reduce(0, fn [_, a, b], acc -> acc + mul_str(a, b) end)
  end

  defp parse_instructions([@pattern_do_c], [_, acc]), do: [1, acc]
  defp parse_instructions([@pattern_dont_c], [_, acc]), do: [0, acc]
  defp parse_instructions([_, a, b], [mode, acc]), do: [mode, acc + mode * mul_str(a, b)]

  def solution_part2(input) do
    input
    |> parse_input(~r/#{@pattern_mul_r}|#{@pattern_dont_r}|#{@pattern_do_r}/)
    |> Enum.reduce([1, 0], &parse_instructions/2)
    |> Enum.at(1)
  end
end

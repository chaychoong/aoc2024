defmodule Aoc.Utils.Test do
  defmacro __using__(_) do
    quote do
      def get_example, do: @example

      def solve_example_part1, do: solution_part1(@example) == @example_part1
      def solve_example_part2, do: solution_part2(@example) == @example_part2

      def solve_part1(input), do: solution_part1(input)
      def solve_part2(input), do: solution_part2(input)
    end
  end
end

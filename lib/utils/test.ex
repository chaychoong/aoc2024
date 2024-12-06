defmodule Aoc.Utils.Test do
  defmacro __using__(_) do
    quote do
      def get_example() do
        @example
      end

      def solve_example_part1 do
        {example_time, example_ans} = :timer.tc(&solution_part1/1, [@example])

        IO.puts("Part 1 example ans: #{example_ans} (#{example_time / 1000}ms)")
        example_ans == @example_part1
      end

      def solve_part1(input) do
        {inp_time, inp_ans} = :timer.tc(&solution_part1/1, [input])

        IO.puts("Part 1 input ans: #{inp_ans} (#{inp_time / 1000}ms)")
        inp_ans
      end

      def solve_example_part2 do
        {example_time, example_ans} = :timer.tc(&solution_part2/1, [@example])

        IO.puts("Part 2 example ans: #{example_ans} (#{example_time / 1000}ms)")
        example_ans == @example_part2
      end

      def solve_part2(input) do
        {inp_time, inp_ans} = :timer.tc(&solution_part2/1, [input])

        IO.puts("Part 2 input ans: #{inp_ans} (#{inp_time / 1000}ms)")
        inp_ans
      end
    end
  end
end

defmodule Aoc2024Test do
  use ExUnit.Case

  defp day_module(day), do: String.to_existing_atom("Elixir.Aoc.Day#{day}")

  for day <- 1..11 do
    describe "Day #{day}" do
      @tag String.to_atom("day#{day}p1")
      test "part 1" do
        assert day_module(unquote(day)).solve_example_part1()

        day_module(unquote(day)).solve_part1(Aoc.Utils.Input.get_input(unquote(day)))
        |> IO.inspect()
      end

      @tag String.to_atom("day#{day}p2")
      test "part 2" do
        assert day_module(unquote(day)).solve_example_part2()

        day_module(unquote(day)).solve_part2(Aoc.Utils.Input.get_input(unquote(day)))
        |> IO.inspect()
      end
    end
  end
end

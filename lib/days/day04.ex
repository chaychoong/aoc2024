defmodule Aoc.Day4 do
  @example """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """
  @example_part1 18
  @example_part2 9

  use Aoc.Utils.Test

  defmacrop at(grid, x, y) do
    quote do
      elem(elem(unquote(grid), unquote(x)), unquote(y))
    end
  end

  defp parse_input(input) do
    grid =
      input
      |> String.split()
      |> Enum.map(&(String.graphemes(&1) |> List.to_tuple()))
      |> List.to_tuple()

    sizeY = tuple_size(grid)
    sizeX = tuple_size(elem(grid, 0))

    {grid, sizeX, sizeY}
  end

  defp directions() do
    for dir_x <- -1..1, dir_y <- -1..1, {dir_x, dir_y} != {0, 0}, do: {dir_x, dir_y}
  end

  defp search(grid, x, y) when at(grid, x, y) == "X" do
    for {dirX, dirY} <- directions(), reduce: 0 do
      acc -> acc + search_next(grid, x + dirX, y + dirY, dirX, dirY, "M")
    end
  end

  defp search(_, _, _), do: 0

  defp next_target("X"), do: "M"
  defp next_target("M"), do: "A"
  defp next_target("A"), do: "S"

  defp search_next(grid, x, y, _, _, "S") when at(grid, x, y) == "S", do: 1

  defp search_next(grid, x, y, dirX, dirY, target) when at(grid, x, y) == target,
    do: search_next(grid, x + dirX, y + dirY, dirX, dirY, next_target(target))

  defp search_next(_, _, _, _, _, _), do: 0

  def solution_part1(input) do
    {grid, sizeX, sizeY} = parse_input(input)

    for x <- 0..(sizeX - 1), y <- 0..(sizeY - 1), reduce: 0 do
      acc -> acc + search(grid, x, y)
    end
  end

  @valid_cross_patterns ~w(MS SM)

  defp check_cross_left(grid, x, y) when (at(grid, x - 1, y - 1) <> at(grid, x + 1, y + 1)) in @valid_cross_patterns,
    do: 1

  defp check_cross_left(_, _, _), do: 0

  defp check_cross_right(grid, x, y) when (at(grid, x - 1, y + 1) <> at(grid, x + 1, y - 1)) in @valid_cross_patterns,
    do: 1

  defp check_cross_right(_, _, _), do: 0

  defp search_A(grid, x, y) when at(grid, x, y) == "A",
    do: check_cross_left(grid, x, y) * check_cross_right(grid, x, y)

  defp search_A(_, _, _), do: 0

  def solution_part2(input) do
    {grid, sizeX, sizeY} = parse_input(input)

    for x <- 0..(sizeX - 1),
        y <- 0..(sizeY - 1),
        reduce: 0 do
      acc -> acc + search_A(grid, x, y)
    end
  end
end

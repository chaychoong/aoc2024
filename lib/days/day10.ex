defmodule Aoc.Day10 do
  @example """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """
  @example_part1 36
  @example_part2 81

  use Aoc.Utils.Test

  def parse_input(input) do
    input
    |> String.split()
    |> Stream.with_index()
    |> Stream.flat_map(fn {row, y_idx} -> parse_row({row, y_idx}) end)
    |> Enum.reduce({%{}, []}, &add_grid_and_trailheads/2)
  end

  defp parse_row({row, y}) do
    row
    |> String.graphemes()
    |> Stream.with_index()
    |> Stream.map(fn {height, x} -> {{x, y}, String.to_integer(height)} end)
  end

  defp add_grid_and_trailheads({pos, 0}, {grid, trailheads}), do: {Map.put(grid, pos, 0), [pos | trailheads]}
  defp add_grid_and_trailheads({pos, height}, {grid, trailheads}), do: {Map.put(grid, pos, height), trailheads}

  defp search(grid, {x, y}, 0), do: search(grid, {x, y}, 0, [])

  defp search(grid, {x, y}, 9, acc) do
    case Map.get(grid, {x, y}) do
      9 -> [{x, y} | acc]
      _ -> acc
    end
  end

  defp search(grid, {x, y}, current_number, acc) do
    case Map.get(grid, {x, y}) do
      ^current_number ->
        adjacent_positions({x, y})
        |> Enum.reduce(acc, fn pos, sub_acc ->
          search(grid, pos, current_number + 1, sub_acc)
        end)

      _ ->
        acc
    end
  end

  defp adjacent_positions({x, y}), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]

  def solution_part1(input) do
    {grid, trailheads} = parse_input(input)

    trailheads
    |> Stream.map(&search(grid, &1, 0))
    |> Stream.map(&Stream.uniq/1)
    |> Stream.map(&Enum.count/1)
    |> Enum.sum()
  end

  def solution_part2(input) do
    {grid, trailheads} = parse_input(input)

    trailheads
    |> Stream.map(&search(grid, &1, 0))
    |> Stream.map(&length/1)
    |> Enum.sum()
  end
end

defmodule Aoc.Day8 do
  @example """
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
  """
  @example_part1 14
  @example_part2 34

  use Aoc.Utils.Test

  def parse_input(input) do
    rows = input |> String.split("\n", trim: true)

    antennas =
      rows
      |> Stream.with_index()
      |> Enum.reduce(%{}, fn {row, x_idx}, row_acc ->
        row
        |> String.graphemes()
        |> Stream.with_index()
        |> Enum.reduce(row_acc, fn {pos, y_idx}, pos_acc ->
          case pos do
            "." -> pos_acc
            antenna -> Map.update(pos_acc, antenna, [{x_idx, y_idx}], &[{x_idx, y_idx} | &1])
          end
        end)
      end)

    max_x = length(rows) - 1
    max_y = length(rows |> List.first() |> String.graphemes()) - 1

    %{antennas: antennas, max_x: max_x, max_y: max_y}
  end

  def unique_pairs(list) do
    for {x, i} <- Stream.with_index(list),
        y <- Stream.drop(list, i + 1),
        do: {x, y}
  end

  def pair_distance({{x1, y1}, {x2, y2}}), do: {x2 - x1, y2 - y1}

  def get_one_antinode({x, y}, {x_dis, y_dis}, op, max_x, max_y) do
    case {op.(x, x_dis), op.(y, y_dis)} do
      {x, y} when x >= 0 and x <= max_x and y >= 0 and y <= max_y -> [{x, y}]
      _ -> []
    end
  end

  def get_all_antinodes(antenna, distance, op, max_x, max_y),
    do: get_all_antinodes(antenna, distance, op, max_x, max_y, [antenna])

  def get_all_antinodes(antenna, distance, op, max_x, max_y, acc) do
    case get_one_antinode(antenna, distance, op, max_x, max_y) do
      [pos] -> get_all_antinodes(pos, distance, op, max_x, max_y, [pos | acc])
      [] -> acc
    end
  end

  def pairs_to_antinodes({left, right}, max_x, max_y, mode \\ :one) do
    distance = pair_distance({left, right})
    antinode_fn = if mode == :one, do: &get_one_antinode/5, else: &get_all_antinodes/5

    [{left, &Kernel.-/2}, {right, &Kernel.+/2}]
    |> Stream.flat_map(fn {antenna, op} -> antinode_fn.(antenna, distance, op, max_x, max_y) end)
  end

  def solution_part1(input) do
    %{antennas: antennas, max_x: max_x, max_y: max_y} = parse_input(input)

    antennas
    |> Map.values()
    |> Stream.flat_map(&unique_pairs/1)
    |> Stream.flat_map(&pairs_to_antinodes(&1, max_x, max_y))
    |> MapSet.new()
    |> MapSet.size()
  end

  def solution_part2(input) do
    %{antennas: antennas, max_x: max_x, max_y: max_y} = parse_input(input)

    antennas
    |> Map.values()
    |> Stream.flat_map(&unique_pairs/1)
    |> Stream.flat_map(&pairs_to_antinodes(&1, max_x, max_y, :all))
    |> MapSet.new()
    |> MapSet.size()
  end
end

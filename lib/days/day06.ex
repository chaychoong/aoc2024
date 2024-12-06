defmodule Aoc.Day6 do
  @example """
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
  """
  @example_part1 41
  @example_part2 6

  use Aoc.Utils.Test

  @up {-1, 0}
  @right {0, 1}
  @down {1, 0}
  @left {0, -1}

  defmodule Grid do
    defstruct obstacles: MapSet.new(),
              visited: MapSet.new(),
              seen: MapSet.new(),
              position: {0, 0},
              direction: {-1, 0},
              max_x: 0,
              max_y: 0,
              status: :ok

    def add_obstacle(%Grid{} = grid, pos), do: %{grid | obstacles: MapSet.put(grid.obstacles, pos)}

    def set_status(%Grid{} = grid, status) when status in [:ok, :obstacle, :end, :loop],
      do: %{grid | status: status}

    def check_loop(%Grid{seen: seen, position: position, direction: direction} = grid) do
      cond do
        MapSet.member?(seen, {position, direction}) -> grid |> Grid.set_status(:loop)
        true -> %{grid | seen: MapSet.put(seen, {position, direction})}
      end
    end

    def set_direction(%Grid{} = grid, direction) do
      %{grid | direction: direction}
      |> Grid.check_loop()
    end

    def set_position(%Grid{} = grid, position) do
      %{grid | position: position, visited: MapSet.put(grid.visited, position)}
      |> Grid.check_loop()
    end

    def turn_right(%Grid{direction: {x, y}} = grid), do: Grid.set_direction(grid, {y, -x})

    def try_walk_to(%Grid{} = grid, {x, y}) when x < 0 or x > grid.max_x or y < 0 or y > grid.max_y,
      do: grid |> Grid.set_status(:end)

    def try_walk_to(%Grid{} = grid, target_pos) do
      cond do
        MapSet.member?(grid.obstacles, target_pos) -> grid |> Grid.set_status(:obstacle)
        true -> grid |> Grid.set_position(target_pos)
      end
    end

    def vector_add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

    def walk(%Grid{status: :obstacle} = grid), do: grid |> Grid.set_status(:ok) |> Grid.turn_right()

    def walk(%Grid{status: :ok} = grid) do
      grid.position
      |> Grid.vector_add(grid.direction)
      |> then(&Grid.try_walk_to(grid, &1))
    end

    def keep_walking(%Grid{status: :loop} = grid), do: grid
    def keep_walking(%Grid{status: :end} = grid), do: grid
    def keep_walking(%Grid{} = grid), do: grid |> Grid.walk() |> Grid.keep_walking()
  end

  def direction_to_vector("^"), do: @up
  def direction_to_vector(">"), do: @right
  def direction_to_vector("v"), do: @down
  def direction_to_vector("<"), do: @left

  def create_grid(grid) do
    max_x = length(grid) - 1
    max_y = length(grid |> List.first()) - 1

    for {x, x_idx} <- Stream.with_index(grid),
        {y, y_idx} <- Stream.with_index(x) do
      {{x_idx, y_idx}, y}
    end
    |> Enum.reduce(%Grid{max_x: max_x, max_y: max_y}, fn {pos, char}, acc ->
      case char do
        "#" ->
          acc |> Grid.add_obstacle(pos)

        direction when direction in ["^", ">", "v", "<"] ->
          direction_vector = direction_to_vector(direction)
          acc |> Grid.set_position(pos) |> Grid.set_direction(direction_vector) |> Grid.set_status(:ok)

        _ ->
          acc
      end
    end)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> create_grid()
  end

  def solution_part1(input) do
    input
    |> parse_input()
    |> Grid.keep_walking()
    |> then(&MapSet.size(&1.visited))
  end

  def check_for_loop(grid, position) do
    grid
    |> Grid.add_obstacle(position)
    |> Grid.keep_walking()
    |> Map.get(:status)
  end

  def solution_part2(input) do
    grid = parse_input(input)

    for x <- 0..grid.max_x, y <- 0..grid.max_y do
      {x, y}
    end
    |> Enum.map(&check_for_loop(grid, &1))
    |> Enum.count(&(&1 == :loop))
  end
end

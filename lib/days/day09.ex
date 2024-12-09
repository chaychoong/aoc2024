defmodule Aoc.Day9 do
  @example """
  2333133121414131402
  """
  @example_part1 1928
  @example_part2 2858

  use Aoc.Utils.Test

  def parse_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Stream.map(&String.to_integer/1)
  end

  defp parse_sequence_p1(sequence) do
    sequence
    |> Enum.reduce({%{spaces: MapSet.new(), files: Map.new()}, 0, 0, :file}, &add_record/2)
    |> elem(0)
  end

  def add_record(count, {acc, id, pos, :file}) do
    file_positions = Map.new(pos..(pos + count - 1), fn pointer -> {pointer, id} end)

    update_in(acc.files, fn files -> Map.merge(files, file_positions) end)
    |> then(&{&1, id, pos + count, :spaces})
  end

  def add_record(0, {acc, id, pos, :spaces}), do: {acc, id + 1, pos, :file}

  def add_record(count, {acc, id, pos, :spaces}) do
    space_positions = MapSet.new(pos..(pos + count - 1))

    update_in(acc.spaces, fn spaces -> MapSet.union(spaces, space_positions) end)
    |> then(&{&1, id + 1, pos + count, :file})
  end

  def solution_part1(input) do
    parsed_input = input |> parse_input() |> parse_sequence_p1()
    size_files = parsed_input |> Map.get(:files) |> Map.keys() |> length()

    parsed_input.files
    |> Stream.filter(fn {k, _} -> k >= size_files end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Stream.zip(parsed_input.spaces |> Enum.sort())
    |> Enum.reduce(parsed_input.files, fn {{old_k, v}, k}, acc ->
      acc
      |> Map.put(k, v)
      |> Map.pop(old_k)
      |> elem(1)
    end)
    |> Enum.reduce(0, fn {k, v}, acc -> k * v + acc end)
  end

  def parse_sequence_p2(sequence) do
    sequence
    |> Enum.reduce({%{spaces: %{}, files: %{}}, 0, 0, :file}, &add_record_p2/2)
    |> elem(0)
  end

  def add_record_p2(count, {acc, id, pos, :file}) do
    acc
    |> put_in([:files, id], %{pos: pos, count: count})
    |> then(&{&1, id, pos + count, :spaces})
  end

  def add_record_p2(0, {acc, id, pos, :spaces}), do: {acc, id + 1, pos, :file}

  def add_record_p2(count, {acc, id, pos, :spaces}) do
    acc
    |> put_in([:spaces, pos], count)
    |> then(&{&1, id + 1, pos + count, :file})
  end

  def find_space([], _), do: {:not_found, nil}
  def find_space([{s_pos, _} | _], {f_pos, _}) when f_pos < s_pos, do: {:not_found, nil}
  def find_space([{s_pos, s_count} | _], {_, f_count}) when f_count <= s_count, do: {:ok, s_pos}
  def find_space([_ | tail], file), do: find_space(tail, file)

  def fill_space(spaces, pos, count) do
    {space_count, spaces} = Map.pop!(spaces, pos)
    Map.put(spaces, pos + count, space_count - count)
  end

  def solution_part2(input) do
    %{files: files, spaces: spaces} = input |> parse_input() |> parse_sequence_p2()

    files
    |> Enum.sort(:desc)
    |> Enum.reduce({files, spaces}, fn {id, file}, {files_acc, spaces_acc} ->
      spaces_acc
      |> Enum.sort_by(fn {k, _v} -> k end)
      |> find_space({file.pos, file.count})
      |> case do
        {:ok, s_pos} ->
          {
            Map.put(files_acc, id, %{file | pos: s_pos}),
            fill_space(spaces_acc, s_pos, file.count)
          }

        {:not_found, _} ->
          {files_acc, spaces_acc}
      end
    end)
    |> elem(0)
    |> Stream.map(fn {id, %{count: count, pos: pos}} ->
      pos..(pos + count - 1)
      |> Enum.reduce(0, &(&1 * id + &2))
    end)
    |> Enum.sum()
  end
end

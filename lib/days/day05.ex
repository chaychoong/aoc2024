defmodule Aoc.Day5 do
  @example """
  47|53
  97|13
  97|61
  97|47
  75|29
  61|13
  75|53
  29|13
  97|29
  53|29
  61|53
  97|53
  61|29
  47|13
  75|47
  97|75
  47|61
  75|61
  47|29
  75|13
  53|13

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  75,97,47,61,53
  61,13,29
  97,13,75,29,47
  """
  @example_part1 143
  @example_part2 123

  use Aoc.Utils.Test

  defp parse_input(input) do
    [rules, updates] =
      input
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n", trim: true))

    parsed_rules =
      rules
      |> Enum.map(fn rule ->
        Regex.scan(~r/\d+/, rule)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
      end)

    parsed_updates =
      updates
      |> Enum.map(fn update ->
        update
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)

    must_be_after_lut =
      parsed_rules
      |> Enum.reduce(%{}, fn [left, right], acc ->
        Map.update(acc, right, [left], fn rest -> [left | rest] end)
      end)

    {parsed_updates, must_be_after_lut}
  end

  defp get_middle_element(update), do: Enum.at(update, div(length(update), 2))

  def process_sorted_p1(sorted, original) when sorted == original, do: get_middle_element(sorted)
  def process_sorted_p1(_, _), do: 0

  def solution_part1(input) do
    {updates, must_be_after_lut} = parse_input(input)

    updates
    |> Stream.map(fn update ->
      update
      |> Enum.sort(&(&1 in Map.get(must_be_after_lut, &2, [])))
      |> process_sorted_p1(update)
    end)
    |> Enum.sum()
  end

  def process_sorted_p2(sorted, original) when sorted == original, do: 0
  def process_sorted_p2(sorted, _), do: get_middle_element(sorted)

  def solution_part2(input) do
    {updates, must_be_after_lut} = parse_input(input)

    updates
    |> Stream.map(fn update ->
      update
      |> Enum.sort(&(&1 in Map.get(must_be_after_lut, &2, [])))
      |> process_sorted_p2(update)
    end)
    |> Enum.sum()
  end
end

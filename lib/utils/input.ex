defmodule Aoc.Utils.Input do
  @moduledoc """
  Common functions we can use for all exercises
  """

  @doc """
  Check if input exists in the /priv folder, else download it from
  adventofcode.com
  """
  @year 2024

  def get_input(day) do
    day_str = String.pad_leading("#{day}", 2, "0")
    path = "priv/day#{day_str}.txt"

    case File.read(path) do
      {:ok, input} ->
        input

      {:error, _} ->
        {:ok, %{body: input}} =
          Req.get("https://adventofcode.com/#{@year}/day/#{day}/input",
            headers: [{"cookie", "session=#{System.fetch_env!("AOC_COOKIE")}"}]
          )

        File.mkdir_p!("priv")
        File.write!(path, input)
        input
    end
  end
end

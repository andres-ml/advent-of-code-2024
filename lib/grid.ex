defmodule Utils.Grid do

  def parse(text), do: text
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))

  def to_string(grid), do: grid
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")

  def at(grid, {i, j}), do: Enum.at(Enum.at(grid, j), i)

  def replace(grid, {i, j}, value), do: List.update_at(grid, j, fn row -> List.update_at(row, i, fn _ -> value end) end)

end

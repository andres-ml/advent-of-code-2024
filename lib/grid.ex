defmodule Utils.Grid do

  def parse(text), do: text
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))

  def to_string(grid), do: grid
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")

  def at(grid, {i, j}), do: Enum.at(Enum.at(grid, i), j)

  def replace(grid, {i, j}, value), do: List.update_at(grid, i, fn row -> List.update_at(row, j, fn _ -> value end) end)

  def transpose(grid), do: grid |> Enum.zip_with(&Function.identity/1)

  def adjacencies({i, j}), do: [
    {i - 1, j},
    {i, j - 1},
    {i + 1, j},
    {i, j + 1},
  ]

end

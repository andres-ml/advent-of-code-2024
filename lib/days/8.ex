defmodule Day8 do

  def parse(input), do: input |> Utils.Grid.parse

  def parse_positions(grid) do
    for {row, i} <- Enum.with_index(grid),
        {char, j} <- Enum.with_index(row),
        char != ".",
        reduce: %{} do acc -> Map.update(acc, char, [{i, j}], &[{i, j} | &1])
    end
  end

  def find_antinodes(list, range \\ 1..1) do
    for a1 = {i1, j1} <- list,
        a2 = {i2, j2} <- list,
        a1 != a2,
        f <- range,
        do: { i1 - f * (i2 - i1), j1 - f * (j2 - j1) }
  end

  def solve(grid, range) do
    size = length(grid)
    parse_positions(grid)
      |> Map.values
      |> Enum.map(&find_antinodes(&1, range))
      |> List.flatten
      |> Enum.filter(fn {i, j} -> i >= 0 and j >= 0 and i < size and j < size end)
      |> Enum.into(MapSet.new)
      |> MapSet.size
  end

  def one(grid), do: solve(grid, 1..1)

  def two(grid) do
    size = length(grid)
    solve(grid, -size..size)
  end

end

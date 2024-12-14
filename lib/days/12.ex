defmodule Day12 do

  def parse(input), do: input |> Utils.Grid.parse

  # splits list of positions into lists of adjacent positions
  def groups([]), do: []
  def groups([p]), do: [[p]]
  def groups([p|rest]) do
    patch = expand([p], rest)
    [patch] ++ groups(rest -- patch)
  end

  # expands group of positions with adjacencies from pool until no more can be added
  def expand([], _), do: []
  def expand(group, pool) do
    adjacencies = group
      |> Enum.map(&Utils.Grid.adjacencies(&1))
      |> List.flatten
      |> Enum.uniq
      |> Enum.filter(&(&1 in pool))
    case adjacencies do
      [] -> group
      adjacencies -> group ++ expand(adjacencies, pool -- adjacencies)
    end
  end

  def area(patch), do: length(patch)

  def perimeter(patch) do
    patch
      |> Enum.map(
        fn position -> position
          |> Utils.Grid.adjacencies
          |> Kernel.--(patch)
          |> length
        end
      )
      |> Enum.sum
  end

  # return a list of vertices of all positions in patch.
  # each {i, j} coordinate represents the top-left vertex
  def vertices(patch) do
    patch
      |> Enum.map(fn {i, j} -> [
        {i, j},
        {i + 1, j},
        {i, j + 1},
        {i + 1, j + 1},
      ] end)
      |> List.flatten
      |> uniqueVertices(patch)
      |> simplify(patch)
      |> Enum.count
  end

  def booleanToInteger(true), do: 1
  def booleanToInteger(false), do: 0

  # ugly check that removes duplicates but keeps 2 of vertices that touch diagonally:
  # A. or .A
  # .A    A.
  def uniqueVertices(vertices, patch) do
    vertices
      |> Enum.uniq
      |> Enum.map(fn vertex = {i, j} ->
        case [
          {i - 1, j - 1} in patch,
          {i - 1, j} in patch,
          {i, j - 1} in patch,
          {i, j} in patch,
        ] |> Enum.map(&booleanToInteger/1) do
          [1, 0, 0, 1] -> [vertex, vertex]
          [0, 1, 1, 0] -> [vertex, vertex]
          _ -> [vertex]
        end
      end)
      |> List.flatten
  end

  # removes redundant vertices (those that don't change the shape when removed)
  def simplify(vertices, patch) do
    redundant = Enum.filter(vertices, fn {i, j} ->
      case [
        {i - 1, j - 1} in patch,
        {i - 1, j} in patch,
        {i, j - 1} in patch,
        {i, j} in patch,
      ] |> Enum.map(&booleanToInteger/1) do
        [1, 1, 0, 0] -> true # top row
        [1, 0, 1, 0] -> true # left row
        [0, 0, 1, 1] -> true # bottom row
        [0, 1, 0, 1] -> true # right row
        [1, 1, 1, 1] -> true # filling
        _ -> false
      end
    end)
    case redundant do
      [] -> vertices
      redundant -> simplify(vertices -- redundant, patch)
    end
  end

  def get_positions_by_crop(grid) do
    for \
      {row, i} <- Enum.with_index(grid),
      {crop, j} <- Enum.with_index(row),
      reduce: %{} do
        acc -> Map.update(acc, crop, [{i, j}], &[{i, j} | &1])
      end
  end

  def one(grid) do
    grid
      |> get_positions_by_crop
      |> Enum.map(fn {_crop, positions} -> groups(positions) end)
      |> Enum.flat_map(&List.wrap/1) # flatten only 1 level
      |> Enum.map(fn patch -> {area(patch), perimeter(patch)} end)
      |> Enum.map(fn {area, perimeter} -> area * perimeter end)
      |> Enum.sum
  end

  def two(grid) do
    grid
      |> get_positions_by_crop
      |> Enum.map(fn {_crop, positions} -> groups(positions) end)
      |> Enum.flat_map(&List.wrap/1) # flatten only 1 level
      |> Enum.map(fn patch -> {area(patch), vertices(patch)} end)
      |> Enum.map(fn {area, vertices} -> area * vertices end)
      |> Enum.sum
  end

end

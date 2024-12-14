defmodule Day10 do

  def paths(positions, p, discernPaths?) do
    # memoization actually shows no performance improvements for me, but whatever
    Memoize.Cache.get_or_run({__MODULE__, :resolve, [p, discernPaths?]}, fn ->
      case Map.get(positions, p) do
        "." -> []
        9 -> [p]
        n ->
          {i, j} = p
          [
            {i - 1, j},
            {i, j - 1},
            {i + 1, j},
            {i, j + 1},
          ] |> Enum.filter(fn neighbour -> Map.get(positions, neighbour, nil) == n + 1 end)
            |> Enum.map(&paths(positions, &1, discernPaths?))
            |> List.flatten
            |> (if discernPaths?, do: &Function.identity/1, else: &Enum.uniq/1).()
      end
    end)
  end

  def solve(grid, discernPaths?) do
    positions = for \
      {row, i} <- Enum.with_index(grid),
      {char, j} <- Enum.with_index(row),
      into: %{},
      do: {{i, j}, case char do
        "." -> "."
        char -> String.to_integer(char)
      end}

    {:ok, _} = Application.ensure_all_started(:memoize)

    positions
      |> Enum.filter(fn {_, char} -> char == 0 end)
      |> Enum.map(fn {position, _} -> paths(positions, position, discernPaths?) end)
      |> Enum.map(&length/1)
      |> Enum.sum
  end

  def parse(input), do: Utils.Grid.parse(input)
  def one(grid), do: solve(grid, false)
  def two(grid), do: solve(grid, true)

end

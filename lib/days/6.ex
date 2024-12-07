defmodule Day6 do

  def parse(input), do: Utils.Grid.parse(input)

  def move(grid, gridSize, guard = {i, j}, direction, visited) do
    directions = Map.get(visited, guard, [])
    if direction in directions do
      :none
    else
      visited = Map.put(visited, guard, [direction | directions])
      {nextGuard = {nextI, nextJ}, nextDirection} = case direction do
        "^" -> {{i, j - 1}, ">"}
        ">" -> {{i + 1, j}, "v"}
        "v" -> {{i, j + 1}, "<"}
        "<" -> {{i - 1, j}, "^"}
      end
      if nextI < 0 or nextI >= gridSize or nextJ < 0 or nextJ >= gridSize do
        visited
      else
        case Utils.Grid.at(grid, nextGuard) do
          "#" -> move(grid, gridSize, guard, nextDirection, visited)
          _ -> move(grid, gridSize, nextGuard, direction, visited)
        end
      end
    end
  end

  def one(grid) do
    direction = "^"
    j = Enum.find_index(grid, &(direction in &1))
    i = Enum.find_index(Enum.at(grid, j), &(&1 == direction))
    guard = {i, j}
    grid
      |> move(Enum.count(grid), guard, direction, %{guard => []})
      |> map_size
  end

  # tried being smart about it and checking which positions are intersections you visit in a direction
  # such that turning would put you on a direction previously used for that intersection, but this doesn't
  # cover cases such as this:
  # ..#..
  # ..++#
  # ..^|.
  # ...|.
  # -O-+.
  # ...#.
  #
  # ...so brute force it is...
  def two(grid) do
    direction = "^"
    j = Enum.find_index(grid, &(direction in &1))
    i = Enum.find_index(Enum.at(grid, j), &(&1 == direction))
    guard = {i, j}
    gridSize = Enum.count(grid)
    initialVisited = %{guard => []}
    visit = fn grid -> move(grid, gridSize, guard, direction, initialVisited) end
    grid
      |> visit.()
      |> Map.keys
      |> Enum.filter(&(&1 != guard))
      |> Enum.map(&Utils.Grid.replace(grid, &1, "#"))
      |> Enum.filter(&(visit.(&1) == :none))
      |> Enum.count
  end
end

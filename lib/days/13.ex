defmodule Day13 do

  def parse(input), do: input
    |> String.split("\n\n")
    |> Enum.map(fn line ->
      [ax, ay, bx, by, prizeX, prizeY] = Regex.scan(~r/\d+/, line)
        |> List.flatten
        |> Enum.map(&String.to_integer/1)
      %{a: {ax, ay}, b: {bx, by}, prize: {prizeX, prizeY}}
    end)

  # claws advance in lines, so there are no 2 paths to the same destination.
  # we just find the intersection of those lines
  def intersectionTokens({ax, ay}, {bx, by}, {prizeX, prizeY}) do
    det = (ax * by) - (ay * bx)
    pressesA = (prizeX * by - prizeY * bx) / det
    pressesB = (prizeY * ax - prizeX * ay) / det
    tokens = pressesA * 3 + pressesB
    case tokens == floor(tokens) do
      true -> floor(tokens)
      false -> nil
    end
  end

  def one(sets), do: sets
    |> Enum.map(fn %{a: a, b: b, prize: prize} -> intersectionTokens(a, b, prize) end)
    |> Enum.filter(&(&1 != nil))
    |> Enum.sum

  def two(sets), do: sets
    |> Enum.map(&Map.update(&1, :prize, nil, fn {x, y} -> {x + 1.0e13, y + 1.0e13} end))
    |> one

end

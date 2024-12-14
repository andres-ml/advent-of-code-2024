defmodule Day14 do

  import Enum

  def parse(input), do: ~r/-?\d+/
    |> Regex.scan(input)
    |> List.flatten
    |> map(&String.to_integer/1)
    |> chunk_every(4)
    |> map(fn [px, py, vx, vy] -> %{p: {px, py}, v: {vx, vy}} end)

  def move(%{p: {px, py}, v: v = {vx, vy}}, times, width, height), do: %{
    p: {
      Utils.Math.modulo(px + times * vx, width),
      Utils.Math.modulo(py + times * vy, height),
    },
    v: v,
  }

  def booleanToInteger(true), do: 1
  def booleanToInteger(false), do: 0
  def one(robots) do
    width = 101
    height = 103
    midX = div(width, 2)
    midY = div(height, 2)
    robots
      |> map(&move(&1, 100, width, height))
      |> map(fn %{p: p} -> p end)
      |> filter(fn {px, py} -> px != midX and py != midY end)
      |> group_by(fn {px, py} -> booleanToInteger(px > midX) + 2 * booleanToInteger(py > midY) end)
      |> map(fn {_, positions} -> length(positions) end)
      |> reduce(&Kernel.*/2)
  end

  def render(robots, width, height) do
    grid = for \
        y <- 0..height-1,
        x <- 0..width-1,
        into: [],
        do: (case robots |> filter(fn %{p: p} -> p == {x, y} end) |> length do
          0 -> "."
          n -> Integer.to_string(n)
        end)
    grid |> chunk_every(width) |> Utils.Grid.to_string()
  end

  def two(robots, seconds \\ 0) do
    width = 101
    height = 103

    # try to find states where both X and Y concentrate at certain points
    # (I tried checking for 10% of rows/cols empty and it worked)
    concentrated? = fn (ns, range) -> ns |> frequencies |> map_size |> Kernel.<=(floor(range * 0.9)) end
    if \
      concentrated?.(robots |> map(fn %{p: {_, py}} -> py end), height) and
      concentrated?.(robots |> map(fn %{p: {px, _}} -> px end), width)
    do
      IO.puts(render(robots, width, height))
      seconds
    else
      two(robots |> map(&move(&1, 1, width, height)), seconds + 1)
    end
  end

end

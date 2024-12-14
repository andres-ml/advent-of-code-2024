defmodule Day11 do

  use Memoize

  defmemo blinks(_, 0), do: 1
  defmemo blinks(0, times), do: blinks(1, times - 1)
  defmemo blinks(n, times) do
    digits = Integer.to_string(n)
    length = String.length(digits)
    case rem(length, 2) do
      1 -> blinks(n * 2024, times - 1)
      0 -> digits
        |> String.split_at(div(length, 2))
        |> Tuple.to_list
        |> Enum.map(&(&1 |> String.to_integer |> blinks(times - 1)))
        |> Enum.sum
    end
  end

  def solve(stones, times) do
    {:ok, _} = Application.ensure_all_started(:memoize)
    stones
      |> Enum.map(&(blinks(&1, times)))
      |> Enum.sum
  end

  def parse(input), do: input
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)

  def one(stones), do: solve(stones, 25)
  def two(stones), do: solve(stones, 75)

end

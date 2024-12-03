defmodule Day1 do

  def parse(input), do: input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.zip_with(&Function.identity/1) # transpose

  def one(lists), do: lists
    |> Enum.map(&Enum.sort/1)
    |> List.zip()
    |> Enum.map(fn {a, b} -> abs(b - a) end)
    |> Enum.reduce(0, &Kernel.+/2)

  def two([left, right]) do
    frequencies = Enum.frequencies(right)
    left
      |> Enum.map(&(&1 * Map.get(frequencies, &1, 0)))
      |> Enum.reduce(0, &Kernel.+/2)
  end

end

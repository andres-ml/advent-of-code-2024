defmodule Day5 do

  def parse(input) do
    [rules, updates] = String.split(input, "\n\n")
    [
      rules
        |> String.split("\n")
        |> Enum.map(&String.split(&1, "|"))
        |> Enum.map(&Enum.map(&1, fn n -> String.to_integer(n) end))
        |> Enum.reduce(%{}, fn [k, v], carry -> Map.update(carry, k, [v], &([v | &1])) end),
      updates
        |> String.split("\n")
        |> Enum.map(&String.split(&1, ","))
        |> Enum.map(&Enum.map(&1, fn n -> String.to_integer(n) end))
    ]
  end

  def sort(_rules, [a]), do: [a]
  def sort(rules, [a | rest]) do
    case Enum.find(rest, fn b -> a in Map.get(rules, b, []) end) do
      nil -> [a | sort(rules, rest)]
      b -> sort(rules, [b, a | rest -- [b]])
    end
  end

  def sumMiddle(lists), do: lists
    |> Enum.map(&(Enum.at(&1, div(Enum.count(&1), 2))))
    |> Enum.sum()

  def one([rules, updates]), do: updates
    |> Enum.filter(&(&1 == sort(rules, &1)))
    |> sumMiddle

  def two([rules, updates]), do: updates
    |> Enum.map(&({&1, sort(rules, &1)}))
    |> Enum.filter(fn {original, sorted} -> original != sorted end)
    |> Enum.map(&elem(&1, 1))
    |> sumMiddle

end

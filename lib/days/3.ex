defmodule Day3 do

  def parse(input), do: input

  def one(input), do: ~r/mul\((\d{1,3}),(\d{1,3})\)/
    |> Regex.scan(input)
    |> Enum.reduce(
      0,
      fn [_, a, b], carry -> carry + String.to_integer(a) * String.to_integer(b) end
    )

  def two(input), do: ~r/
    mul\((\d{1,3}),(\d{1,3})\)
    | (do\(\))
    | (don't\(\))
  /x
    |> Regex.scan(input)
    |> Enum.map(
      fn groups -> groups
        |> Enum.drop(1)
        |> Enum.filter(&(&1 != ""))
      end
    )
    |> Enum.reduce(
      {1, 0},
      fn instruction, {factor, result} ->
        case instruction do
          ["don't()"] -> {0, result}
          ["do()"] -> {1, result}
          [a, b] -> {factor, result + factor * (String.to_integer(a) * String.to_integer(b))}
        end
      end
    )
    |> elem(1)

end

defmodule Day7 do

  def parse(input), do: input
    |> String.split("\n")
    |> Enum.map(fn line ->
      [result | operands] = Regex.scan(~r/\d+/, line) |> List.flatten |> Enum.map(&String.to_integer/1)
      {result, operands}
    end)

  def solvable?(result, carry, [], _), do: result == carry
  def solvable?(result, carry, [operand | rest], operators), do: Enum.any?(
    operators,
    fn operator -> solvable?(result, operator.(carry, operand), rest, operators) end
  )

  def solve(lines, operators), do: lines
    |> Enum.filter(fn {result, [first | rest]} -> solvable?(result, first, rest, operators) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum

  def one(lines), do: solve(lines, [&Kernel.+/2, &Kernel.*/2])
  def two(lines), do: solve(lines, [
    &Kernel.+/2,
    &Kernel.*/2,
    fn a, b -> [a, b]
      |> Enum.map(&Integer.to_string/1)
      |> Enum.join
      |> String.to_integer
    end
  ])

end

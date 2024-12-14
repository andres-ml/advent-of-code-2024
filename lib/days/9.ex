defmodule Day9 do

  import Utils.Grid
  import Utils.Math

  def parse(input) do
    input <> "0" # padding for transposition
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> transpose
      |> (fn [blocks, free] -> [Enum.with_index(blocks), free] end).()
      |> transpose
      |> List.flatten
      |> Enum.filter(&(&1 != 0)) # remove empty spaces
  end

  # note that this does not really work with IDs over 10
  def print(list), do: list
    |> Enum.map(fn
      {length, id} -> String.duplicate(Integer.to_string(id), length)
      space -> String.duplicate(".", space)
    end)
    |> List.flatten
    |> Enum.join("")

  def checksum(list), do: list
    |> Enum.reduce(
      {0, 0},
      fn
        {length, id}, {sum, index} -> {
          sum + id * floor(length * (2 * index + length - 1) / 2),
          index + length
        }
        space, {sum, index} -> {sum, index + space}
      end)
    |> elem(0)

  def defragment1(result, [], _, _), do: Enum.reverse(result)

  def defragment1(result, _, _, remaining) when remaining <= 0, do: Enum.reverse(result)

  def defragment1(result, [{length, id} | rest], reversed, remaining), do:
    defragment1([{clamp(length, 0, remaining), id} | result], rest, reversed, remaining - length)

  def defragment1(result, [space | rest], reversed, remaining) when space == 0, do:
    defragment1(result, rest, reversed, remaining)

  def defragment1(result, [space | rest], [{length, id} | restReversed], remaining) when space < length, do:
    defragment1([{clamp(space, 0, remaining), id} | result], rest, [{length - space, id} | restReversed], remaining - space)

  def defragment1(result, [space | rest], [{length, id} | restReversed], remaining) when space >= length, do:
    defragment1([{clamp(length, 0, remaining), id} | result], [space - length | rest], restReversed, remaining - length)

  def one(list) do
    blocks = list |> Enum.filter(&Kernel.is_tuple/1)
    size = blocks |> Enum.map(&elem(&1, 0)) |> Enum.sum()
    defragmented = defragment1([], list, blocks |> Enum.reverse, size)
    checksum(defragmented)
  end

  def mergeSpaces([]), do: []
  def mergeSpaces([a]), do: [a]
  def mergeSpaces([a, b | rest]) when is_integer(a) and is_integer(b), do: mergeSpaces([a + b | rest])
  def mergeSpaces([a | rest]), do: [a | mergeSpaces(rest)]

  # Disclaimer: this performs a lot of incredibly inefficient list concatenations
  def defragment2(list), do: list
    # all blocks
    |> Enum.filter(&Kernel.is_tuple/1)
    # starting from the right
    |> Enum.reverse
    |> Enum.reduce(list, fn {length, id}, defragmented ->
      blockIndex = Enum.find_index(defragmented, fn {^length, ^id} -> true; _ -> false end)
      case defragmented
        |> Enum.with_index
        |> Enum.find(fn
          {{_, _}, _} -> false
          {space, spaceIndex} -> space >= length and spaceIndex < blockIndex
        end)
      do
        nil -> defragmented
        {space, spaceIndex} ->
          Enum.slice(defragmented, 0..spaceIndex-1//1)
            ++ [{length, id}]
            ++ [space - length]
            ++ Enum.slice(defragmented, spaceIndex+1..blockIndex-1//1)
            ++ [length]
            ++ Enum.slice(defragmented, blockIndex+1..-1//1)
            |> mergeSpaces
      end
    end)

  def two(list), do: list
    |> defragment2
    |> checksum

end

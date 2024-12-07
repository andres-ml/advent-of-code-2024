defmodule Day4 do

  def parse(input), do: input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))

  def count(grid), do: grid
    |> Enum.map(
      fn row -> row
        |> Enum.join("")
        |> (fn line ->
          [~r/XMAS/, ~r/SAMX/]
            |> Enum.map(&Regex.scan(&1, line))
            |> List.flatten
            |> Enum.count
        end).()
      end
    )
    |> Enum.sum()

  def transpose(grid), do: grid |> Enum.zip_with(&Function.identity/1)
  def flip(grid), do: grid |> Enum.map(&Enum.reverse/1)

  # builds a new matrix, double the size, where each row is shifted one position to the right or left
  def shift(grid, left?) do
    size = Enum.count(grid)
    base = if left?, do: 0, else: size - 1
    grid
      |> Enum.with_index()
      |> Enum.map(fn {row, index} ->
        List.duplicate(".", abs(base - index)) ++ row ++ List.duplicate(".", abs(size - base - index - 1))
      end)
  end

  def one(grid), do: 0 +
      count(grid) +
      count(grid |> transpose) +
      count(grid |> shift(true) |> transpose) +
      count(grid |> shift(false) |> transpose)

  def two(grid) do
    size =  Enum.count(grid)
    findCrosses = fn text, result, recur ->
      case Regex.run(~r/
        (S|M).(S|M).{#{size - 3 + 1}} # -3 cross size, +1 for the newline
            .A.    .{#{size - 3 + 1}}
        (S|M).(S|M)
      /x, text) do
        # store corners and keep matching, but consume the center "A"
        [match | rest] -> recur.(
            String.replace(text, match, Utils.String.replaceCharAt(match, size + 1, "F"), global: false),
            result ++ [rest],
            recur
          )
        nil -> result
      end
    end

    grid
      |> Enum.map(&Enum.join/1)
      |> Enum.join("N") # any char for newlines
      |> findCrosses.([], findCrosses)
      |> Enum.filter(fn [nw, ne, sw, se] -> nw != se and sw != ne end)
      |> Enum.count
  end

end

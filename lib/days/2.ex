defmodule Day2 do

  def parse(input), do: input
    |> String.split("\n")
    |> Enum.map(
      fn line -> Enum.map(String.split(line), &String.to_integer/1) end
    )

  def safe(report = [level1, level2 | _rest]), do: report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.all?(
        fn [a, b] ->
          distance = abs(a - b)
          a < b == level1 < level2
            and distance >= 1
            and distance <= 3
        end
      )

  def one(reports), do: reports
    |> Enum.filter(&safe/1)
    |> Enum.count

  def two(reports), do: reports
    |> Enum.filter(
      fn report -> Enum.any?(
          0..Enum.count(report),
          &(
            report
              |> List.delete_at(&1)
              |> safe
          )
        )
      end
    )
    |> Enum.count

end

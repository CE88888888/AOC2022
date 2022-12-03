defmodule Day3 do
  def parse(example \\ false) do
    Input.parse(3, example)
    |> String.split("\r\n")
  end

  def solve1(example \\ false) do
    parse(example)
    |> Enum.map(fn x -> Tuple.to_list(String.split_at(x, div(String.length(x), 2))) end)
    |> Enum.map(fn [x, y] -> String.myers_difference(x, y)[:eq] end)
    |> Enum.map(&hd(String.to_charlist(&1)))
    |> Enum.map(&map_prio(&1))
    |> Enum.sum()
  end

  def solve2(example \\ false) do
    parse(example)
    |> Enum.chunk_every(3)
    |> Enum.map(fn y -> Enum.map(y, fn x -> MapSet.new(String.to_charlist(x)) end) end)
    |> Enum.map(fn y -> Enum.reduce(y, fn x, acc -> MapSet.intersection(x, acc) end) end)
    |> Enum.map(&map_prio(Enum.at(&1, 0)))
    |> Enum.sum()
  end

  def map_prio(c) do
    cond do
      c > 96 -> c - 96
      c > 64 -> c - 38
      true -> 0
    end
  end
end

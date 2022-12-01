defmodule Day1 do
  def parse(example \\ false) do
    Input.parse(1, example)
    |> String.split("\r\n\r")
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, "\r"))
    |> Stream.map(fn x -> Enum.map(x, &String.to_integer(&1)) end)
    |> Enum.map(&Enum.sum(&1))
  end

  def solve1(example \\ false) do
    parse(example)
    |> Enum.max()
  end

  def solve2(example \\ false) do
    parse(example)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end
end

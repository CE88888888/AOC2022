defmodule Day4 do
  def parse(example \\ false) do
    Input.parse(4, example)
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn y -> Enum.flat_map(y, &List.flatten(String.split(&1, "-"))) end)
    |> Enum.map(fn y -> Enum.map(y, fn x -> String.to_integer(x) end) end)
    |> Enum.map(fn x -> sort_elves(x) end)
  end

  def solve1(example \\ false) do
    parse(example)
    |> Enum.filter(fn [x,y,a,b] -> x >= a and y <= b end)
    |> Enum.count()
  end

  def solve2(example \\ false) do
    parse(example)
    |> Enum.filter(fn x -> overlap?(x) end)
    |> Enum.count()
  end

  def sort_elves([x, y, a, b]) do
    cond do
      y - x < b - a -> [x, y, a, b]
      y - x > b - a -> [a, b, x, y]
      y - x == b - a -> [x, y, a, b]
    end
  end

  def overlap?([x, y, a, b]) do
    cond do
      x >= a and x <= b -> true
      y >= a and y <= b -> true
      true -> false
    end
  end
end

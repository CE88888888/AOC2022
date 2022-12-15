defmodule Day15 do
  def parse(example \\ false) do
    Input.parse(15, example)
    |> String.replace("Sensor at x=", "") |> String.replace(" y=", "") |> String.replace(" closest beacon is at x=", "")
    |> String.split("\r\n")
    |> Enum.map(& String.split(&1,":"))
    |> Enum.map(fn x -> Enum.map(x, & String.split(&1,",")) end)
    |> Enum.map(& Enum.concat(&1))
    |> Enum.map(& Enum.map(&1, fn x -> String.to_integer(x) end))
  end

  def solve1(example \\ false) do
    parse(example)
    |> Enum.map(fn [x1,y1,x2,y2] -> [x1,y1,x2,y2, Day15.mh({x1,y1},{x2,y2})] end)
    |> Enum.reduce(MapSet.new(), fn [x1,y1,_x2,_y2, mhd], acc -> MapSet.union(mark_area(x1,y1,mhd), acc) end)
  end

  def solve2(example \\ false) do
    example
  end

  def mh(a, b) do
    {x1, y1} = a
    {x2, y2} = b
    abs(x1-x2) + abs(y1-y2)
  end

  def mark_area(x,y,mhd) do
    for i <- -mhd..mhd,
      j <- -mhd..mhd,
      mh({x,y},{x+i,y+j}) <= mhd do
      [x+i, y+j]
    end
    |> MapSet.new()
  end
end

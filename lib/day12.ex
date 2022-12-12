defmodule Day12 do
  def parse(example \\ false) do
    Input.parse(12, example)
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes(&1))
  end

  def solve1(example \\ false) do
    chart = init(example)
    start = Enum.find(chart, fn {_x, _y, v, _w} -> v == "S" end)

    dijkstra(chart, [start], [], "E")
    |> Enum.at(0)
  end

  def solve2(example \\ false) do
    chart = init(example)
    start = Enum.find(chart, fn {_x, _y, v, _w} -> v == "E" end)

    dijkstra(chart, [start], [], "a")
    |> Enum.at(0)
  end

  def dijkstra(chart, candidates, visited, char_to_end) do
    [c | candidates] = candidates
    visited = [c | visited]
    {x, y, v, _w} = c
    chart = Enum.reject(chart, fn {x1, y1, _v1, _w} -> x == x1 and y == y1 end)
    nbs = nb(chart, c, char_to_end)
    candidates = merge_lists(candidates, nbs)

    cond do
      v == char_to_end -> visited
      Enum.empty?(candidates) -> visited
      Enum.empty?(chart) -> visited
      true -> dijkstra(chart, candidates, visited, char_to_end)
    end
  end

  def nb(unvisited, current, char_to_end) do
    {x, y, v, w} = current

    case char_to_end do
      "E" ->
        Enum.filter(unvisited, fn {x1, y1, v1, _w1} ->
          ((x1 in (x - 1)..(x + 1) and y == y1) or (y1 in (y - 1)..(y + 1) and x == x1)) and cp(v1) <= cp(v) + 1
        end)

      "a" ->
        Enum.filter(unvisited, fn {x1, y1, v1, _w1} ->
          ((x1 in (x - 1)..(x + 1) and y == y1) or (y1 in (y - 1)..(y + 1) and x == x1)) and cp(v1) >= cp(v) - 1
        end)
    end
    |> Enum.filter(fn {x1, y1, _z, _w} -> !(x1 == x and y1 == y) end)
    |> Enum.map(fn {x1, y1, z1, w1} -> {x1, y1, z1, w1 + w + 1} end)
    |> Enum.sort_by(fn {_x1, _y1, _v1, w1} -> w1 end, :asc)
  end

  def init(example \\ false) do
    input = parse(example)

    for y <- 0..(length(input) - 1) do
      row = Enum.at(input, y)

      for x <- 0..(length(row) - 1) do
        v = Enum.at(row, x)
        {x, y, v, 0}
      end
    end
    |> Enum.concat()
  end

  def merge_lists(candidates, nbs) do
    {conflict, new} =
      Enum.split_with(nbs, fn {x1, y1, _v1, _w1} ->
        {x1, y1} in Enum.map(candidates, fn {x2, y2, _v2, _w2} -> {x2, y2} end)
      end)

    candidates =
      Enum.map(candidates, fn {x1, y1, v1, w1} ->
        if {x1, y1} in Enum.map(conflict, fn {x2, y2, _v2, _w2} -> {x2, y2} end) do
          weight = elem(Enum.find(conflict, fn {x3, y3, _v3, _w3} -> x1 == x3 and y1 == y3 end), 3)

          if weight < w1 do
            {x1, y1, v1, weight}
          else
            {x1, y1, v1, w1}
          end
        else
          {x1, y1, v1, w1}
        end
      end)

    candidates = Enum.concat(new, candidates)
    Enum.sort_by(candidates, fn {_x1, _y1, _v1, w1} -> w1 end, :asc)
  end

  def cp(char) do
    case char do
      "S" -> hd(String.to_charlist(char)) + 100
      "E" -> 122
      _ -> hd(String.to_charlist(char))
    end
  end
end

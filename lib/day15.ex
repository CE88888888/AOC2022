defmodule Day15 do
  def parse(example \\ false) do
    Input.parse(15, example)
    |> String.replace("Sensor at x=", "")
    |> String.replace(" y=", "")
    |> String.replace(" closest beacon is at x=", "")
    |> String.split("\r\n")
    |> Stream.map(&String.split(&1, ":"))
    |> Stream.map(fn x -> Enum.map(x, &String.split(&1, ",")) end)
    |> Stream.map(&Stream.concat(&1))
    |> Stream.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
    |> Stream.map(fn [x1, y1, x2, y2] -> [x1, y1, mh({x1, y1}, {x2, y2})] end)
  end

  def solve1(example \\ false) do
    y_to_find = if example, do: 10, else: 2_000_000

    [range] = parse(example) |> find_row(y_to_find)
    Range.size(range) - 1
  end

  def solve2(example \\ false) do
    space = if example, do: 20, else: 4_000_000
    sensors = parse(example) |> Enum.sort()

    {x, y} =
      try do
        for r <- 0..space,
            elem(check_row(sensors, r), 0) == true do
          throw({elem(check_row(sensors, r), 1), r})
        end

        :error
      catch
        result -> result
      end

    x * 4_000_000 + y
  end

  def find_row(sensors, y_to_find) do
    Stream.filter(sensors, fn [_x, y, mhd] -> y_to_find in (y - mhd)..(y + mhd) end)
    |> Stream.map(fn [x, y, mhd] ->
      if y < y_to_find do
        [x, y, mhd, abs(y + mhd - y_to_find)]
      else
        [x, y, mhd, abs(y - mhd - y_to_find)]
      end
    end)
    |> Stream.map(fn [x, _y, _mhd, size] -> (x - size)..(x + size) end)
    |> Enum.sort()
    |> Enum.reduce([], fn x, acc ->
      cond do
        acc == [] -> [x | acc]
        Range.disjoint?(List.first(acc), x) -> [x | acc]
        true -> [Enum.min(List.first(acc))..max(Enum.max(x), Enum.max(List.first(acc))) | tl(acc)]
      end
    end)
  end

  def check_row(sensors, y_to_find) do
    range = find_row(sensors, y_to_find) |> Enum.sort()

    cond do
      length(range) == 1 -> {false, range}
      true -> {true, Enum.max(Enum.at(range, 0)) + 1}
    end
  end

  def mh(a, b) do
    {x1, y1} = a
    {x2, y2} = b
    abs(x1 - x2) + abs(y1 - y2)
  end
end

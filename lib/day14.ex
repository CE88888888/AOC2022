defmodule Day14 do
  def parse(example \\ false) do
    Input.parse(14, example)
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, " -> ", trim: true))
    |> Enum.map(&Enum.map(&1, fn x -> Enum.map(String.split(x, ","), fn y -> String.to_integer(y) end) end))
  end

  def solve1(example \\ false) do
    input = parse(example)
    walls = Enum.reduce(input, MapSet.new(), fn x, acc -> MapSet.union(acc, plot_line(acc, x)) end)
    maxdepth = MapSet.to_list(walls) |> Enum.map(fn [_x, y] -> y end) |> Enum.max()

    filled = fill({:start, walls}, maxdepth)
    MapSet.difference(filled, walls) |> Enum.count()
  end

  def solve2(example \\ false) do
    input = parse(example)

    walls = Enum.reduce(input, MapSet.new(), fn x, acc -> MapSet.union(acc, plot_line(acc, x)) end)
    maxdepth = MapSet.to_list(walls) |> Enum.map(fn [_x, y] -> y end) |> Enum.max() |> Kernel.+(2)

    floor =
      for x <- -1000..1000 do
        [x, maxdepth]
      end

    fm = MapSet.new(floor)
    walls = MapSet.union(fm, walls)
    filled = fill({:start, walls}, maxdepth)

    MapSet.difference(filled, walls) |> Enum.count() |> Kernel.+(1)
  end

  def fill(occupied, max_depth) do
    y = MapSet.to_list(elem(occupied, 1)) |> Enum.map(fn [_x, y] -> y end) |> Enum.max()

    cond do
      elem(occupied, 0) == :stop -> elem(occupied, 1)
      y > max_depth -> elem(occupied, 1)
      true -> fill(move_sp(elem(occupied, 1), [500, 0], max_depth), max_depth)
    end
  end

  def move_sp(occupied, position, max_depth) do
    [x, y] = position

    cond do
      y >= max_depth ->
        {:stop, occupied}

      !MapSet.member?(occupied, [x, y + 1]) ->
        move_sp(occupied, [x, y + 1], max_depth)

      !MapSet.member?(occupied, [x - 1, y + 1]) ->
        move_sp(occupied, [x - 1, y + 1], max_depth)

      !MapSet.member?(occupied, [x + 1, y + 1]) ->
        move_sp(occupied, [x + 1, y + 1], max_depth)

      position == [500, 0] ->
        {:stop, occupied}

      true ->
        IO.puts("position: #{x}, #{y}")
        {:continue, MapSet.put(occupied, position)}
    end
  end

  def plot_line(grid, line) do
    l = length(line) - 1

    walls =
      for i <- 0..(l - 1), j <- 1..l, i == j - 1 do
        [x1, y1] = Enum.at(line, i)
        [x2, y2] = Enum.at(line, j)

        cond do
          x1 != x2 ->
            points = Enum.to_list(Range.new(x1, x2))

            for p <- points do
              [p, y1]
            end

          y1 != y2 ->
            points = Enum.to_list(Range.new(y1, y2))

            for p <- points do
              [x1, p]
            end
        end
      end
      |> Enum.concat()

    MapSet.union(grid, MapSet.new(walls))
  end
end

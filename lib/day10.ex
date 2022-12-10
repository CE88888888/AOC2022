defmodule Day10 do
  def parse(example \\ false) do
    Input.parse(10, example)
    |> String.split("\r\n")
    |> Enum.map(& if &1 == "noop" do [&1, 1] else [&1, 2] end)
    |> Enum.map_reduce(0, fn [x, y], acc -> {[x, y, acc + y], acc + y} end)
    |> elem(0)
  end

  def solve1(example \\ false) do
    parse(example)
    |> signal_strength(6)
  end

  def solve2(example \\ false) do
    parse(example)
    |> draw_line(239)
  end

  def signal_strength(cycles, n) do
    for i <- 0..(n - 1) do
      sum_cycles(cycles, 20 + i * 40) * (20 + i * 40)
    end
    |> Enum.sum()
  end

  def sum_cycles(cycles, n) do
      Enum.take_while(cycles, fn [_x, _y, z] -> z < n end)
      |> Enum.filter(fn x -> hd(x) != "noop" end)
      |> Enum.map(fn [x, _y, _z] -> String.split(x) end)
      |> Enum.map(fn [_x, y] -> String.to_integer(y) end)
      |> Enum.sum()
      |> Kernel.+(1)
  end

  def draw_line(cycles, max) do
    Enum.map(0..max, &[&1, rem(&1, 40), sum_cycles(cycles, &1 + 1)])
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.map(&1, fn [_i, c, x] -> [c, x, x == c or c == x + 1 or c == x - 1] end))
    |> Enum.map(&create_draw_string(&1))
  end

  def create_draw_string(l) do
    Enum.map(l, fn [_x, _y, z] -> if z do "#" else "." end end)
    |> Enum.join()
  end
end

defmodule Day13 do
  def parse(example \\ false) do
    Input.parse(13, example)
    |> String.split("\r\n\r")
    |> Enum.with_index(1)
    |> Enum.map(fn {x, index} -> {index, String.replace(x, "\n", "")} end)
    |> Enum.map(fn {x, y} -> {x, String.split(y, "\r")} end)
    |> Enum.map(fn {x, y} -> {x, Enum.map(y, &elem(Code.eval_string(&1), 0))} end)
  end

  def solve1(example \\ false) do
    parse(example)
    |> Enum.map(fn {x, [l, r]} -> {x, compare(l, r)} end)
    |> Enum.filter(fn {_x, y} -> y end)
    |> Enum.reduce(0, fn {x, _y}, acc -> acc + x end)
  end

  def solve2(example \\ false) do
    packets =
      parse(example)
      |> Enum.map(fn {_x, y} -> y end)
      |> Enum.concat()

    (packets ++ [[[2]]] ++ [[[6]]])
    |> Enum.sort(fn a, b -> compare(a, b) end)
    |> Enum.with_index(1)
    |> Enum.filter(fn {x, _y} -> x == [[2]] or x == [[6]] end)
    |> Enum.reduce(1, fn {_x, y}, acc -> acc * y end)
  end

  def compare(l, r) when is_integer(l) and is_integer(r) do
    cond do
      l == r -> :continue
      l < r -> true
      l > r -> false
    end
  end

  def compare(left, right) when is_integer(left) and is_list(right) do
    compare([left], right)
  end

  def compare(left, right) when is_integer(right) and is_list(left) do
    compare(left, [right])
  end

  def compare(left, right) when is_list(left) and is_list(right) do
    Enum.zip_reduce(Stream.concat(left, [:stop]), Stream.concat(right, [:stop]), :continue, fn
      _, _, false -> false
      _, _, true -> true
      :stop, :stop, _acc -> :continue
      :stop, _, _acc -> true
      _, :stop, _acc -> false
      l, r, :continue -> compare(l, r)
    end)
  end
end

defmodule Day6 do
  def parse(example \\ false) do
    Input.parse(6, example)
    |> String.graphemes()
  end

  def solve1(example \\ false) do
    input = parse(example)

    try do
      for i <- 3..(length(input) - 4),
          is_distinct?(Enum.slice(input, (i - 3)..i), 4) do
        throw(i + 1)
      end

      :error
    catch
      result -> result
    end
  end

  def solve2(example \\ false) do
    input = parse(example)

    try do
      for i <- 13..(length(input) - 13),
          is_distinct?(Enum.slice(input, (i - 13)..i), 14) do
        throw(i + 1)
      end

      :error
    catch
      result -> result
    end
  end

  def is_distinct?(list, n) do
    ulist = Enum.uniq(list) |> length()
    ulist == n
  end
end

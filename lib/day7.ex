defmodule Day7 do
  def parse(example \\ false) do
    Input.parse(7, example)
    |> String.split("\r\n")
  end

  def solve1(example \\ false) do
    input = parse(example)

    files =
      parse_tree(input, 1, ["/"], [])
      |> Enum.map(&Enum.reverse(&1))

    dirs = files |> Enum.group_by(&Enum.at(&1, 0))

    Enum.map(dirs, fn {x, y} ->
      {String.reverse(x),
       Enum.reduce(y, 0, fn [a, b, c], acc -> reducer(dirs, [a, b, c], acc) end)}
    end)
    |> Enum.filter(fn x -> elem(x, 1) <= 100_000 end)
    |> Enum.map(fn {_x, y} -> y end)
    |> Enum.sum()
  end

  def solve2(example \\ false) do
    input = parse(example)

    files =
      parse_tree(input, 1, ["/"], [])
      |> Enum.map(&Enum.reverse(&1))

    dirs = files |> Enum.group_by(&Enum.at(&1, 0))

    dirsizes =
      Enum.map(dirs, fn {x, y} ->
        {String.reverse(x),
         Enum.reduce(y, 0, fn [a, b, c], acc -> reducer(dirs, [a, b, c], acc) end)}
      end)

    max = Enum.filter(dirsizes, &(elem(&1, 0) == "/")) |> Enum.at(0) |> elem(1)

    freespace = 70_000_000 - max
    space_to_delete = 30_000_000 - freespace

    dirsizes
    |> Enum.filter(fn x -> elem(x, 1) >= space_to_delete end)
    |> Enum.sort_by(fn {_x, y} -> y end)
    |> Enum.at(0)
    |> elem(1)
  end

  def parse_tree(input, index, path, acc) do
    instruction = Enum.at(input, index)

    cond do
      instruction == nil ->
        acc

      instruction == "$ ls" ->
        parse_tree(input, index + 1, path, get_content(input, index + 1, path) ++ acc)

      instruction == "$ cd .." ->
        parse_tree(input, index + 1, tl(path), acc)

      String.starts_with?(instruction, "$ cd") ->
        parse_tree(input, index + 1, [String.trim_leading(instruction, "$ cd ")] ++ path, acc)

      true ->
        parse_tree(input, index + 1, path, acc)
    end
  end

  def get_content(input, index, path) do
    ins = Enum.slice(input, index..-1)

    Enum.take_while(ins, &(!String.starts_with?(&1, "$")))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&(&1 ++ [Enum.join(path, "-")]))
  end

  def reducer(dirs, [a, b, c], acc) do
    cond do
      c == "dir" ->
        subs = Map.get(dirs, b <> "-" <> a)
        Enum.reduce(subs, acc, fn [a, b, c], acc -> reducer(dirs, [a, b, c], acc) end)

      true ->
        acc + String.to_integer(c)
    end
  end
end

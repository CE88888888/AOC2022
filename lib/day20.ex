defmodule Day20 do
  def parse(example \\ false) do
    Input.parse(20, example)
    |> String.split("\r\n")
    |> Enum.map(&String.to_integer(&1))
  end

  def solve1(example \\ false) do
    mixorder = Enum.with_index(parse(example))
    new = Enum.reduce(0..(length(mixorder) - 1), mixorder, fn x, acc -> rotate(acc, Enum.at(mixorder, x)) end)
    zero = Enum.find_index(new, &(elem(&1, 0) == 0))

    {x, _} = Enum.at(new, Integer.mod(1000 + zero, length(mixorder)))
    {y, _} = Enum.at(new, Integer.mod(2000 + zero, length(mixorder)))
    {z, _} = Enum.at(new, Integer.mod(3000 + zero, length(mixorder)))

    x + y + z
  end

  def solve2(example \\ false) do
    list = parse(example) |> Enum.map(&(&1 * 811_589_153))
    mixorder = Enum.with_index(list)

    new =
      Enum.reduce(0..9, mixorder, fn _x, acc ->
        Enum.reduce(0..(length(mixorder) - 1), acc, fn x, acc -> rotate(acc, Enum.at(mixorder, x)) end)
      end)

    zero = Enum.find_index(new, &(elem(&1, 0) == 0))

    {x, _} = Enum.at(new, Integer.mod(1000 + zero, length(list)))
    {y, _} = Enum.at(new, Integer.mod(2000 + zero, length(list)))
    {z, _} = Enum.at(new, Integer.mod(3000 + zero, length(list)))

    x + y + z
  end

  def rotate(list, i) do
    {val, order_index} = i

    if val == 0 do
      list
    else
      index = Enum.find_index(list, &(&1 == {val, order_index}))
      list = List.delete_at(list, index)
      List.insert_at(list, Integer.mod(index + val, length(list) - 1), i)
    end
  end
end

defmodule Day9 do
  def parse(example \\ false) do
    Input.parse(9, example)
    |> String.split("\r\n")
    |> Enum.map(fn x -> String.split(x, " ") end)
    |> Enum.map(fn [x, y] -> [x, String.to_integer(y)] end)
    |> Enum.flat_map(fn [x, y] ->
      for _i <- 1..y do
        [x]
      end
    end)
  end

  def init_rope(knots) do
    start = MapSet.new([{0, 0}])
    rope = %{hx: 0, hy: 0, h: start, tail: []}
    totalrope = List.duplicate(rope, knots)

    Enum.reduce(totalrope, rope, fn r, acc -> Map.put(r, :tail, acc) end)
  end

  def solve1(example \\ false) do
    input = parse(example)
    rope = init_rope(1)

    follow_instructions(input, rope)
    |> get_last_knot()
    |> Enum.count()
  end

  def solve2(example \\ false) do
    input = parse(example)
    rope = init_rope(9)

    follow_instructions(input, rope)
    |> get_last_knot()
    |> Enum.count()
  end

  def follow_instructions(input, rope) do
    Enum.reduce(input, rope, fn i, acc -> move_rope(acc, i) end)
  end

  def get_last_knot(rope) do
    cond do
      rope.tail == [] -> rope.h
      true -> get_last_knot(rope.tail)
    end
  end

  def move_rope(rope, instruction) do
    i = instruction

    case i do
      ["R"] ->
        Map.update!(rope, :tail, fn _r -> update_tail(rope.hx + 1, rope.hy, rope.tail) end)
        |> Map.update!(:hx, fn _x -> rope.hx + 1 end)

      ["U"] ->
        Map.update!(rope, :tail, fn _r -> update_tail(rope.hx, rope.hy + 1, rope.tail) end)
        |> Map.update!(:hy, fn _x -> rope.hy + 1 end)

      ["L"] ->
        Map.update!(rope, :tail, fn _r -> update_tail(rope.hx - 1, rope.hy, rope.tail) end)
        |> Map.update!(:hx, fn _x -> rope.hx - 1 end)

      ["D"] ->
        Map.update!(rope, :tail, fn _r -> update_tail(rope.hx, rope.hy - 1, rope.tail) end)
        |> Map.update!(:hy, fn _x -> rope.hy - 1 end)

      _ ->
        rope
    end
  end

  def update_tail(_x, _y, []) do
    []
  end

  def update_tail(x, y, tail) do
    dx = abs(x - tail.hx)
    dy = abs(y - tail.hy)

    newtail =
      if dx <= 1 and dy <= 1 do
        tail
      else
        newx =
          cond do
            x > tail.hx -> tail.hx + 1
            x < tail.hx -> tail.hx - 1
            x == tail.hx -> tail.hx
          end

        newy =
          cond do
            y > tail.hy -> tail.hy + 1
            y < tail.hy -> tail.hy - 1
            y == tail.hy -> tail.hy
          end

        %{
          hx: newx,
          hy: newy,
          tail: update_tail(newx, newy, tail.tail),
          h: tail.h
        }
      end

    # only keep track of the last knot
    if tail.tail == [] do
      Map.update!(newtail, :h, fn x -> MapSet.put(x, {newtail.hx, newtail.hy}) end)
    else
      newtail
    end
  end
end

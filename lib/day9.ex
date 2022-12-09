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

  def solve1(example \\ false) do
    input = parse(example)

    visited = MapSet.new([{0, 0}])
    rope = %{hx: 0, hy: 0, tx: 0, ty: 0, h: visited}

    rope = follow_instructions(input, rope)

    rope.h |> Enum.count()
  end

  def solve2(example \\ false) do
    example
  end

  def follow_instructions(input, rope) do
    Enum.reduce(input, rope, fn i, acc -> move_rope(acc, i) end)
  end

  def move_rope(rope, instruction) do
    i = instruction
    IO.inspect({rope.hx, rope.hy, rope.tx, rope.ty}, label: Enum.at(i, 0))

    case i do
      ["R"] ->
        rope = update_tail(%{hx: rope.hx + 1, hy: rope.hy, tx: rope.tx, ty: rope.ty, h: rope.h})
        Map.update!(rope, :h, fn _x -> MapSet.put(rope.h, {rope.tx, rope.ty}) end)

      ["U"] ->
        rope = update_tail(%{hx: rope.hx, hy: rope.hy + 1, tx: rope.tx, ty: rope.ty, h: rope.h})
        Map.update!(rope, :h, fn _x -> MapSet.put(rope.h, {rope.tx, rope.ty}) end)

      ["L"] ->
        rope = update_tail(%{hx: rope.hx - 1, hy: rope.hy, tx: rope.tx, ty: rope.ty, h: rope.h})
        Map.update!(rope, :h, fn _x -> MapSet.put(rope.h, {rope.tx, rope.ty}) end)

      ["D"] ->
        rope = update_tail(%{hx: rope.hx, hy: rope.hy - 1, tx: rope.tx, ty: rope.ty, h: rope.h})
        Map.update!(rope, :h, fn _x -> MapSet.put(rope.h, {rope.tx, rope.ty}) end)

      _ ->
        rope
    end
  end

  def update_tail(rope) do
    dx = abs(rope.hx - rope.tx)
    dy = abs(rope.hy - rope.ty)

    cond do
      dx == 0 and dy == 0 ->
        rope

      dx <= 1 and dy <= 1 ->
        rope

      dx == 2 and dy == 0 ->
        newx =
          if rope.hx > rope.tx do
            rope.tx + 1
          else
            rope.tx - 1
          end

        %{hx: rope.hx, hy: rope.hy, tx: newx, ty: rope.ty, h: rope.h}

      dx == 0 and dy == 2 ->
        newy =
          if rope.hy > rope.ty do
            rope.ty + 1
          else
            rope.ty - 1
          end

        %{hx: rope.hx, hy: rope.hy, tx: rope.tx, ty: newy, h: rope.h}

      true ->
        newx =
          if rope.hx > rope.tx do
            rope.tx + 1
          else
            rope.tx - 1
          end

        newy =
          if rope.hy > rope.ty do
            rope.ty + 1
          else
            rope.ty - 1
          end

        %{hx: rope.hx, hy: rope.hy, tx: newx, ty: newy, h: rope.h}
    end
  end
end

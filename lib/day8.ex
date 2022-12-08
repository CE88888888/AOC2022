defmodule Day8 do
  def parse(example \\ false) do
    Input.parse(8, example)
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes(&1))
  end

  def init(input) do
    for y <- 0..(length(input) - 1) do
      row = Enum.at(input, y)

      for x <- 0..(length(row) - 1) do
        %{x: x, y: y, v: String.to_integer(Enum.at(row, x))}
      end
    end
    |> Enum.concat()
  end

  def solve1(example \\ false) do
    input = parse(example)
    treemap = init(input)
    count_trees(treemap)
  end

  def solve2(example \\ false) do
    input = parse(example)
    treemap = init(input)

    Enum.map(treemap, &trees_visible(treemap, &1))
    |> Enum.max()
  end

  def count_trees(treemap) do
    Enum.filter(treemap, &tree_visible?(treemap, &1))
    |> Enum.count()
  end

  def tree_visible?(treemap, tree) do
    vertical = Enum.filter(treemap, &(&1.x == tree.x))
    top = List.first(vertical)
    bot = List.last(vertical)
    horizontal = Enum.filter(treemap, &(&1.y == tree.y))
    left = List.first(horizontal)
    right = List.last(horizontal)

   top_max =
      if length(t = Enum.filter(vertical, &(&1.y >= top.y and &1.y < tree.y))) > 0 do
        Enum.max_by(t, & &1.v)
      else
        %{x: -1, y: -1, v: 0}
      end

    bot_max =
      if length(b = Enum.filter(vertical, &(&1.y <= bot.y and &1.y > tree.y))) > 0 do
       Enum.max_by(b, & &1.v)
      else
        %{x: -1, y: -1, v: 0}
      end

    left_max =
      if length(l = Enum.filter(horizontal, &(&1.x >= left.x and &1.x < tree.x))) > 0 do
        Enum.max_by(l, & &1.v)
      else
        %{x: -1, y: -1, v: 0}
      end

    right_max =
      if length(r = Enum.filter(horizontal, &(&1.x <= right.x and &1.x > tree.x))) > 0 do
        Enum.max_by(r, & &1.v)
      else
        %{x: -1, y: -1, v: 0}
      end

    cond do
      Enum.member?([top, bot, left, right], tree) -> true
      tree.v > top_max.v -> true
      tree.v > bot_max.v -> true
      tree.v > left_max.v -> true
      tree.v > right_max.v -> true
      true -> false
    end
  end

  def trees_visible(treemap, tree) do
    vertical = Enum.filter(treemap, &(&1.x == tree.x))
    top = Enum.filter(vertical, &(&1.y < tree.y)) |> Enum.reverse()
    bot = Enum.filter(vertical, &(&1.y > tree.y))
    horizontal = Enum.filter(treemap, &(&1.y == tree.y))
    left = Enum.filter(horizontal, &(&1.x < tree.x)) |> Enum.reverse()
    right = Enum.filter(horizontal, &(&1.x > tree.x))

    cond do
      Enum.empty?(top) -> 0
      Enum.empty?(bot) -> 0
      Enum.empty?(left) -> 0
      Enum.empty?(right) -> 0

      true ->
        top_count = Enum.take_while(top, &(&1.v < tree.v)) |> Enum.count()
        bot_count = Enum.take_while(bot, &(&1.v < tree.v)) |> Enum.count()
        left_count = Enum.take_while(left, &(&1.v < tree.v)) |> Enum.count()
        right_count = Enum.take_while(right, &(&1.v < tree.v)) |> Enum.count()

        top_count =
          if top_count < Enum.count(top) do
            top_count + 1
          else
            top_count
          end

        bot_count =
          if bot_count < Enum.count(bot) do
            bot_count + 1
          else
            bot_count
          end

        left_count =
          if left_count < Enum.count(left) do
            left_count + 1
          else
            left_count
          end

        right_count =
          if right_count < Enum.count(right) do
            right_count + 1
          else
            right_count
          end

        left_count * right_count * top_count * bot_count
    end
  end
end

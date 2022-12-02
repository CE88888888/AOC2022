defmodule Day2 do
  def parse(example \\ false) do
    Input.parse(2, example)
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn x -> Enum.map(x, &map_input(&1)) end)
  end

  def solve1(example \\ false) do
    parse(example)
    |> Enum.reduce(0, fn x, acc -> calc_round(x) + acc end)
  end

  def solve2(example \\ false) do
    parse(example)
    #|> Enum.reduce(0, fn x, acc -> calc_round2(x) + acc end)
    |> Enum.reduce(0, fn x, acc -> calc_round2(x) + acc end)
  end

  def map_input(s) do
    case s do
      # Rock
      "A" -> 1
      # Paper
      "B" -> 2
      # Scissors
      "C" -> 3
      # Rock
      "X" -> 1
      # Paper
      "Y" -> 2
      # Scissors
      "Z" -> 3
    end
  end

  def calc_round([o, p]) do
    case o do
      # Rock
      1 ->
        cond do
          # Rock vs Rock
          p == 1 -> p + 3
          # Rock vs Paper
          p == 2 -> p + 6
          # Rock vs Scissors
          true -> p
        end

      # Paper
      2 ->
        cond do
          # Paper vs Rock
          p == 1 -> p
          # Paper vs Paper
          p == 2 -> p + 3
          # Paper vs Scissors
          true -> p + 6
        end

      # Scissors
      3 ->
        cond do
          # Scissors vs Rock
          p == 1 -> p + 6
          # Scissors vs Paper
          p == 2 -> p
          # Scissors vs Scissors
          true -> p + 3
        end
    end
  end

  def calc_round2([o, p]) do
    case o do
      # Rock
      1 ->
        cond do
          p == 1 -> 3
          p == 2 -> 4
          true -> 8
        end

      # Paper
      2 ->
        cond do
          p == 1 -> 1
          p == 2 -> 5
          true -> 9
        end

      # Scissors
      3 ->
        cond do
          p == 1 -> 2
          p == 2 -> 6
          true -> 7
        end
    end
  end
end

defmodule Day12Test do
  use ExUnit.Case

  test "day12_1_example" do
    assert Day12.solve1(true) == {5, 2, "E", 31}
  end

  test "day12_1" do
    assert Day12.solve1() == {52, 20, "E", 394}
  end

  test "day12_2_example" do
    assert Day12.solve2(true) == {0, 4, "a", 29}
  end

  test "day12_2" do
    assert Day12.solve2() == {0, 10, "a", 388}
  end

end

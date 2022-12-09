defmodule Day9Test do
  use ExUnit.Case

  test "day9_1_example" do
    assert Day9.solve1(true) == 13
  end

  test "day9_1" do
    assert Day9.solve1() == 6642
  end

  test "day9_2_example" do
    assert Day9.solve2(true) == 1
  end

  test "day9_2" do
    assert Day9.solve2() == 2765
  end

end

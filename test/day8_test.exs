defmodule Day8Test do
  use ExUnit.Case

  test "day8_1_example" do
    assert Day8.solve1(true) == 21
  end

  test "day8_1" do
    assert Day8.solve1() == 1662
  end

  test "day8_2_example" do
    assert Day8.solve2(true) == 8
  end

  test "day8_2" do
    assert Day8.solve2() == 537_600
  end
end

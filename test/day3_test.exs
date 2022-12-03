defmodule Day3Test do
  use ExUnit.Case

  test "day3_1_example" do
    assert Day3.solve1(true) == 157
  end

  test "day3_1" do
    assert Day3.solve1() == 8243
  end

  test "day3_2_example" do
    assert Day3.solve2(true) == 70
  end

  test "day3_2" do
    assert Day3.solve2() == 2631
  end

end

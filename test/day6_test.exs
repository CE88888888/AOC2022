defmodule Day6Test do
  use ExUnit.Case

  test "day6_1_example" do
    assert Day6.solve1(true) == 7
  end

  test "day6_1" do
    assert Day6.solve1() == 1647
  end

  test "day6_2_example" do
    assert Day6.solve2(true) == 19
  end

  test "day6_2" do
    assert Day6.solve2() == 2447
  end

end

defmodule Day15Test do
  use ExUnit.Case

  test "day15_1_example" do
    assert Day15.solve1(true) == 26
  end

  test "day15_1" do
    assert Day15.solve1() == 4737443
  end

  test "day15_2_example" do
    assert Day15.solve2(true) == 56000011
  end

  test "day15_2" do
    assert Day15.solve2() == 11482462818989
  end

end

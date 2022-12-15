defmodule Day15Test do
  use ExUnit.Case

  test "day15_1_example" do
    assert Day15.solve1(true) == true
  end

  test "day15_1" do
    assert Day15.solve1() == false
  end

  test "day15_2_example" do
    assert Day15.solve2(true) == true
  end

  test "day15_2" do
    assert Day15.solve2() == false
  end

end

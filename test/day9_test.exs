defmodule Day9Test do
  use ExUnit.Case

  test "day9_1_example" do
    assert Day9.solve1(true) == true
  end

  test "day9_1" do
    assert Day9.solve1() == false
  end

  test "day9_2_example" do
    assert Day9.solve2(true) == true
  end

  test "day9_2" do
    assert Day9.solve2() == false
  end

end

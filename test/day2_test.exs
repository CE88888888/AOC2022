defmodule Day2Test do
  use ExUnit.Case

  test "day2_1_example" do
    assert Day2.solve1(true) == true
  end

  test "day2_1" do
    assert Day2.solve1() == false
  end

  test "day2_2_example" do
    assert Day2.solve2(true) == true
  end

  test "day2_2" do
    assert Day2.solve2() == false
  end

end

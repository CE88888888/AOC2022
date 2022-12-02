defmodule Day2Test do
  use ExUnit.Case

  test "day2_1_example" do
    assert Day2.solve1(true) == 15
  end

  test "day2_1" do
    assert Day2.solve1() == 8933
  end

  test "day2_2_example" do
    assert Day2.solve2(true) == 12
  end

  test "day2_2" do
    assert Day2.solve2() == 11998
  end

end

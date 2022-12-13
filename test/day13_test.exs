defmodule Day13Test do
  use ExUnit.Case

  test "day13_1_example" do
    assert Day13.solve1(true) == 13
  end

  test "day13_1" do
    assert Day13.solve1() == 5825
  end

  test "day13_2_example" do
    assert Day13.solve2(true) == 140
  end

  test "day13_2" do
    assert Day13.solve2() == 24477
  end

end

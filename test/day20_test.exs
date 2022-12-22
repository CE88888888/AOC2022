defmodule Day20Test do
  use ExUnit.Case

  test "day20_1_example" do
    assert Day20.solve1(true) == true
  end

  test "day20_1" do
    assert Day20.solve1() == false
  end

  test "day20_2_example" do
    assert Day20.solve2(true) == true
  end

  test "day20_2" do
    assert Day20.solve2() == false
  end

end

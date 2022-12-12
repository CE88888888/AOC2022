defmodule Day12Test do
  use ExUnit.Case

  test "day12_1_example" do
    assert Day12.solve1(true) == 31
  end

  test "day12_1" do
    assert Day12.solve1() == 528
  end

  test "day12_2_example" do
    assert Day12.solve2(true) == 29
  end

  test "day12_2" do
    assert Day12.solve2() == 388
  end

end

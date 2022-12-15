defmodule Day14Test do
  use ExUnit.Case

  test "day14_1_example" do
    assert Day14.solve1(true) == 24
  end

  test "day14_1" do
    assert Day14.solve1() == 1133
  end

  test "day14_2_example" do
    assert Day14.solve2(true) == 93
  end

  # test "day14_2" do
  #   assert Day14.solve2() == 27566
  # end

end

defmodule Day4Test do
  use ExUnit.Case

  test "day4_1_example" do
    assert Day4.solve1(true) == 2
  end

  test "day4_1" do
    assert Day4.solve1() == 464
  end

  test "day4_2_example" do
    assert Day4.solve2(true) == 4
  end

  test "day4_2" do
    assert Day4.solve2() == 770
  end

end

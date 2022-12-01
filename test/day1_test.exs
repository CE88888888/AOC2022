defmodule Day1Test do
  use ExUnit.Case

  test "day1_1_example" do
    assert Day1.solve1(true) == 24000
  end

  test "day1_1" do
    assert Day1.solve1() == 66616
  end

  test "day1_2_example" do
    assert Day1.solve2(true) == 45000
  end

  test "day1_2" do
    assert Day1.solve2() == 199172
  end

end

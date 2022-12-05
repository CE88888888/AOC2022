defmodule Day5Test do
  use ExUnit.Case

  test "day5_1_example" do
    assert Day5.solve1(true) == "CMZ"
  end

  test "day5_1" do
    assert Day5.solve1() == "JDTMRWCQJ"
  end

  test "day5_2_example" do
    assert Day5.solve2(true) == "MCD"
  end

  test "day5_2" do
    assert Day5.solve2() == "VHJDDCWRD"
  end

end

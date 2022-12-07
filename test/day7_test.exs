defmodule Day7Test do
  use ExUnit.Case

  test "day7_1_example" do
    assert Day7.solve1(true) == 95437
  end

  test "day7_1" do
    assert Day7.solve1() == 1749646
  end

  test "day7_2_example" do
    assert Day7.solve2(true) == 1498966
  end

  test "day7_2" do
    assert Day7.solve2() == 24933642
  end

end

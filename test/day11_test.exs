defmodule Day11Test do
  use ExUnit.Case

  test "day11_1_example" do
    assert Day11.solve1(true) == 10605
  end

  test "day11_1" do
    assert Day11.solve1() == 119715
  end

  test "day11_2_example" do
    assert Day11.solve2(true) == 2713310158
  end

  test "day11_2" do
    assert Day11.solve2() == 18085004878
  end

end

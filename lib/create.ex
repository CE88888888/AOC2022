defmodule Create do
  def day(x) do

    content = """
    defmodule Day#{x} do
      def parse(example \\\\ false) do
        Input.parse(#{x}, example)
        |> String.split(\"\\r\\n\")
      end

      def solve1(example \\\\ false) do
        example
      end

      def solve2(example \\\\ false) do
        example
      end
    end
    """

    IO.inspect(File.cwd)
    x = Integer.to_string(x)
    File.touch!("lib/day#{x}.ex")
    File.touch!("input/day#{x}.txt")
    File.touch!("input/day#{x}ex.txt")
    File.write("lib/day#{x}.ex", content)
    create_tests(x)
  end

  defp create_tests(day) do
    content = """
    defmodule Day#{day}Test do
      use ExUnit.Case

      test \"day#{day}_1_example\" do
        assert Day#{day}.solve1(true) == true
      end

      test \"day#{day}_1\" do
        assert Day#{day}.solve1() == false
      end

      test \"day#{day}_2_example\" do
        assert Day#{day}.solve2(true) == true
      end

      test \"day#{day}_2\" do
        assert Day#{day}.solve2() == false
      end

    end
    """
    File.write("test/day#{day}_test.exs", content)
  end

end

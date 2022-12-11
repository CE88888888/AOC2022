defmodule Day11 do
  use Agent

  def parse(example \\ false) do
    Input.parse(11, example)
    |> String.split("\r\n\r")
    |> Enum.map(&monkey_parse(&1))
  end

  def solve1(example \\ false) do
    solver(20, false, example)
  end

  def solve2(example \\ false) do
    solver(10000, true, example)
  end

  def solver(rounds, ex2, example \\ false) do
    input = parse(example)
    divproduct = Enum.reduce(input, 1, fn x, acc -> x.testdiv * acc end)
    monkeys = summon_monkeys(input)

    for _i <- 1..rounds do
      for i <- monkeys do
        m = Agent.get(i, & &1)
        turn(m, divproduct, ex2)
      end
    end

    Enum.map(monkeys, fn x -> Agent.get(x, & &1.inspects) end)
    |> Enum.sort()
    |> Enum.take(-2)
    |> Enum.product()
  end

  def summon_monkeys(list) do
    monkeys = Enum.map(list, fn x -> elem(Agent.start_link(fn -> x end), 1) end)

    for i <- 0..(length(monkeys) - 1) do
      pid = Enum.at(monkeys, i)
      Agent.update(pid, fn m -> Map.update!(m, :pid, fn _x -> pid end) end)
      Agent.update(pid, fn m -> Map.update!(m, :iftrue, fn _x -> Enum.at(monkeys, m.iftrue) end) end)
      Agent.update(pid, fn m -> Map.update!(m, :iffalse, fn _x -> Enum.at(monkeys, m.iffalse) end) end)
    end

    monkeys
  end

  def monkey_parse(monkeystring) do
    list = String.split(monkeystring, "\r\n", trim: true)
    index = String.to_integer(List.first(Regex.run(~r/(\d+)/, List.first(list), capture: :first)))

    starting_items =
      Enum.map(Regex.scan(~r/(\d+)/, Enum.at(list, 1), capture: :first), fn [x] -> String.to_integer(x) end)

    operation = List.first(Regex.run(~r/(?>Operation: new = )(.*)/, Enum.at(list, 2), capture: :all_but_first))
    test = String.to_integer(List.first(Regex.run(~r/(\d+)/, Enum.at(list, 3), capture: :first)))
    iftrue = String.to_integer(List.first(Regex.run(~r/(\d+)/, Enum.at(list, 4), capture: :first)))
    iffalse = String.to_integer(List.first(Regex.run(~r/(\d+)/, Enum.at(list, 5), capture: :first)))

    %{
      pid: 0,
      index: index,
      items: starting_items,
      testdiv: test,
      iftrue: iftrue,
      iffalse: iffalse,
      operation: operation,
      inspects: 0
    }
  end

  def turn(monkey, divproduct, ex2 \\ false) do
    for i <- monkey.items do
      newworry =
        if ex2 do
          op(monkey.operation, i)
        else
          div(op(monkey.operation, i), 3)
        end

      if rem(newworry, monkey.testdiv) == 0 do
        Agent.update(monkey.iftrue, fn m -> Map.update!(m, :items, fn x -> x ++ [rem(newworry, divproduct)] end) end)
      else
        Agent.update(monkey.iffalse, fn m -> Map.update!(m, :items, fn x -> x ++ [rem(newworry, divproduct)] end) end)
      end

      Agent.update(monkey.pid, fn m -> Map.update!(m, :inspects, fn x -> x + 1 end) end)
    end

    Agent.update(monkey.pid, fn m -> Map.update!(m, :items, fn _x -> [] end) end)
  end

  def op(operation, worry) do
    ops = String.split(operation)

    x1 =
      cond do
        Enum.at(ops, 0) == "old" -> worry
        true -> String.to_integer(Enum.at(ops, 0))
      end

    x2 =
      cond do
        Enum.at(ops, 2) == "old" -> worry
        true -> String.to_integer(Enum.at(ops, 2))
      end

    case Enum.at(ops, 1) do
      "+" -> x1 + x2
      "*" -> x1 * x2
    end
  end
  #-----------------------------Just trying to speed up thing-------------------------------------------
  def speed_2_example(example \\ false) do
    input = parse(example)
    mi = Enum.map(0..3, fn _x -> elem(Agent.start_link(fn -> 0 end), 1) end)
    divproduct = Enum.reduce(input, 1, fn x, acc -> x.testdiv * acc end)
    items = Enum.map(input, fn x -> Enum.map(x.items, fn i -> [x.index, i] end) end) |> Enum.concat()

    get_inspects(items, mi, divproduct, 10000)
    Enum.map(mi, fn x -> Agent.get(x, & &1) end) |> Enum.sort() |> Enum.take(-2) |> Enum.product()
  end

  def get_inspects(items, mi, divproduct, n) do
    case n do
      1 -> Enum.map(items, fn [x, y] -> round_calc([x, y], mi, divproduct) end)
      _ -> get_inspects(Enum.map(items, fn [x, y] -> round_calc([x, y], mi, divproduct) end), mi, divproduct, n - 1)
    end
  end

  def round_calc([i, x], mi, divproduct) do
    [ni, nx] =
      case i do
        0 ->
          x = x * 19
          Agent.update(Enum.at(mi, 0), fn x -> x + 1 end)

          cond do
            rem(x, 23) != 0 and rem(x + 3, 17) == 0 ->
              Agent.update(Enum.at(mi, 3), fn x -> x + 1 end)
              # 0.3.0
              [0, x + 3]

            rem(x, 23) != 0 and rem(x + 3, 17) != 0 ->
              Agent.update(Enum.at(mi, 3), fn x -> x + 1 end)
              # 0.3.1
              [1, x + 3]

            rem(x, 23) == 0 and rem(x * x, 13) == 0 ->
              Agent.update(Enum.at(mi, 2), fn x -> x + 1 end)
              # 0.2.1
              [1, x * x]

            rem(x, 23) == 0 and rem(x * x, 13) != 0 and rem(x * x + 3, 17) == 0 ->
              Agent.update(Enum.at(mi, 2), fn x -> x + 1 end)
              Agent.update(Enum.at(mi, 3), fn x -> x + 1 end)
              # 0.2.3.0
              [0, x * x + 3]

            rem(x, 23) == 0 and rem(x * x, 13) != 0 and rem(x * x + 3, 17) != 0 ->
              Agent.update(Enum.at(mi, 2), fn x -> x + 1 end)
              Agent.update(Enum.at(mi, 3), fn x -> x + 1 end)
              # 0.2.3.1
              [1, x * x + 3]
          end

        1 ->
          x = x + 6
          Agent.update(Enum.at(mi, 1), fn x -> x + 1 end)

          cond do
            rem(x, 19) != 0 ->
              # 0
              [0, x]

            rem(x, 19) == 0 and rem(x * x, 13) == 0 ->
              Agent.update(Enum.at(mi, 2), fn x -> x + 1 end)
              # 2.1
              [1, x * x]

            rem(x, 19) == 0 and rem(x * x, 13) != 0 and rem(x * x + 3, 17) == 0 ->
              Agent.update(Enum.at(mi, 2), fn x -> x + 1 end)
              Agent.update(Enum.at(mi, 3), fn x -> x + 1 end)
              # 2.3.0
              [0, x * x + 3]

            rem(x, 19) == 0 and rem(x * x, 13) != 0 and rem(x * x + 3, 17) != 0 ->
              Agent.update(Enum.at(mi, 2), fn x -> x + 1 end)
              Agent.update(Enum.at(mi, 3), fn x -> x + 1 end)
              # 2.3.1
              [1, x * x + 3]
          end

        2 ->
          x = x * x
          Agent.update(Enum.at(mi, 2), fn x -> x + 1 end)

          cond do
            rem(x, 13) == 0 ->
              # 1
              [1, x]

            rem(x, 13) != 0 and rem(x + 3, 17) == 0 ->
              Agent.update(Enum.at(mi, 3), fn x -> x + 1 end)
              # 3.0
              [0, x + 3]

            rem(x, 13) != 0 and rem(x + 3, 17) != 0 ->
              Agent.update(Enum.at(mi, 3), fn x -> x + 1 end)
              # 3.1
              [1, x + 3]
          end

        3 ->
          x = x + 3
          Agent.update(Enum.at(mi, 3), fn x -> x + 1 end)

          cond do
            # 0
            rem(x, 17) == 0 -> [0, x]
            # 1
            rem(x, 17) != 0 -> [1, x]
          end
      end

    [ni, rem(nx, divproduct)]
  end
end

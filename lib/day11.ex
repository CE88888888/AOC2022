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

    %{
      pid: 0,
      index: String.to_integer(List.first(Regex.run(~r/(\d+)/, List.first(list), capture: :first))),
      items: Enum.map(Regex.scan(~r/(\d+)/, Enum.at(list, 1), capture: :first), fn [x] -> String.to_integer(x) end),
      testdiv: String.to_integer(List.first(Regex.run(~r/(\d+)/, Enum.at(list, 3), capture: :first))),
      iftrue: String.to_integer(List.first(Regex.run(~r/(\d+)/, Enum.at(list, 4), capture: :first))),
      iffalse: String.to_integer(List.first(Regex.run(~r/(\d+)/, Enum.at(list, 5), capture: :first))),
      operation: List.first(Regex.run(~r/(?>Operation: new = )(.*)/, Enum.at(list, 2), capture: :all_but_first)),
      inspects: 0
    }
  end

  def turn(monkey, divproduct, ex2 \\ false) do
    Agent.cast(monkey.pid, fn m -> Map.update!(m, :inspects, fn x -> x + length(monkey.items) end) end)
    for i <- monkey.items do
      newworry =
        if ex2 do
          op(monkey.operation, i)
        else
          div(op(monkey.operation, i), 3)
        end

      if rem(newworry, monkey.testdiv) == 0 do
        Agent.cast(monkey.iftrue, fn m -> Map.update!(m, :items, fn x -> x ++ [rem(newworry, divproduct)] end) end)
      else
        Agent.cast(monkey.iffalse, fn m -> Map.update!(m, :items, fn x -> x ++ [rem(newworry, divproduct)] end) end)
      end
    end

    Agent.cast(monkey.pid, fn m -> Map.update!(m, :items, fn _x -> [] end) end)
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

  # -----------------------------Just trying to speed it up---------------------
  # -----------------------------only minor improvement-------------------------
  def speed_2(example \\ false) do
    input = parse(example)
    mi = Enum.map(0..(length(input) - 1), fn _x -> elem(Agent.start_link(fn -> 0 end), 1) end)
    divproduct = Enum.reduce(input, 1, fn x, acc -> x.testdiv * acc end)
    items = Enum.map(input, fn x -> Enum.map(x.items, fn i -> [i, x.index] end) end) |> Enum.concat()

    get_inspects(input, items, mi, divproduct, 10000)
    Enum.map(mi, fn x -> Agent.get(x, & &1) end) |> Enum.sort() |> Enum.take(-2) |> Enum.product()
  end

  def get_inspects(monkeys, items, mi, divproduct, n) do
    case n do
      1 ->
        Enum.map(items, fn [x, y] -> check(x, Enum.at(monkeys, y), monkeys, mi, divproduct) end)

      _ ->
        get_inspects(
          monkeys,
          Enum.map(items, fn [x, y] -> check(x, Enum.at(monkeys, y), monkeys, mi, divproduct) end),
          mi,
          divproduct,
          n - 1
        )
    end
  end

  def check(x, monkey, monkeys, mi, divproduct) do
    Agent.cast(Enum.at(mi, monkey.index), fn x -> x + 1 end)
    x = rem(op(monkey.operation, x), divproduct)

    cond do
      rem(x, monkey.testdiv) == 0 ->
        cond do
          monkey.iftrue < monkey.index -> [x, monkey.iftrue]
          true -> check(x, Enum.at(monkeys, monkey.iftrue), monkeys, mi, divproduct)
        end

      true ->
        cond do
          monkey.iffalse < monkey.index -> [x, monkey.iffalse]
          true -> check(x, Enum.at(monkeys, monkey.iffalse), monkeys, mi, divproduct)
        end
    end
  end
end

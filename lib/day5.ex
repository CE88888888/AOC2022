defmodule Day5 do
  def parse(example \\ false) do
    Input.parse(5, example)
    |> String.split("\r\n\r")
  end

  def solve1(example \\ false) do
    input = parse(example)
    start = Enum.at(input, 0)
    instructions = Enum.at(input, 1)

    stacks = init_stacks(start)
    instructions = init_instructions(instructions)
    #Run it!
    Enum.map(instructions, & move(&1, stacks))

    for x <- 1..length(stacks)-1  do
      Agent.get(Enum.at(stacks,x), fn a-> hd(a) end)
    end
    |> Enum.join()
  end

  def solve2(example \\ false) do
    input = parse(example)
    start = Enum.at(input, 0)
    instructions = Enum.at(input, 1)

    stacks = init_stacks(start)
    instructions = init_instructions(instructions)
    #Run it!
    Enum.map(instructions, & move9001(&1, stacks))

    for x <- 1..length(stacks)-1  do
      Agent.get(Enum.at(stacks,x), fn a-> hd(a) end)
    end
    |> Enum.join()
  end

  def init_stacks(input) do
    s= input
    |> String.split("\r\n")
    |> Enum.map(&String.replace(&1, "    ", "."))
    |> Enum.map(&String.replace(&1, " ", ""))
    |> Enum.map(&String.replace(&1, "[", ""))
    |> Enum.map(&String.replace(&1, "]", ""))
    |> Enum.map(&String.graphemes(&1))
    |> transpose()
    |> Enum.map(& Enum.reverse(&1))
    |> Enum.map(fn x-> Enum.filter(x, & &1!=".") end)
    #add zero index entry so we can use index as stack number
    [[0,"."]]++s
    |> Enum.map(fn x -> Agent.start_link fn -> Enum.reverse(tl(x)) end end)
    |> Enum.map(fn {_x,y} -> y end)

  end

  def init_instructions(input) do
    input
    |> String.replace("\n", "")
    |> String.replace("move ", "")
    |> String.replace("from ", "")
    |> String.replace("to ", "")
    |> String.split("\r")
    |> Enum.map(& String.split(&1, " "))
    |> Enum.map(fn x -> Enum.map(x, & String.to_integer(&1)) end)
  end

  def move([n, x, y], stacks) do
    crates = Agent.get(Enum.at(stacks,x), fn x-> x end)|> Enum.take(n) |> List.flatten() |> Enum.reverse()
    Agent.update(Enum.at(stacks,x), fn list -> Enum.drop(list, n) end)
    Agent.update(Enum.at(stacks,y), fn list -> crates ++ list end)
  end

  def move9001([n, x, y], stacks) do
    crates = Agent.get(Enum.at(stacks,x), fn x-> x end)|> Enum.take(n) |> List.flatten()
    Agent.update(Enum.at(stacks,x), fn list -> Enum.drop(list, n) end)
    Agent.update(Enum.at(stacks,y), fn list -> crates ++ list end)
  end

  def transpose([]), do: []
  def transpose([[] | _]), do: []

  def transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end
end

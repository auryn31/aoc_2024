defmodule Day07 do
  def part1(content) do
    lines =
      String.split(content, "\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&parseLine/1)
      |> Enum.filter(&isPossible/1)
      |> Enum.map(fn {x, _} -> x end)
      |> Enum.sum()

    # IO.inspect(lines)
  end

  defp expressions(numbers) do
    generate_expressions(numbers, [])
  end

  defp generate_expressions([num], expression) do
    [expression ++ [num]]
  end

  defp generate_expressions([head | tail], expression) do
    add = generate_expressions(tail, expression ++ [head, :+])
    multiply = generate_expressions(tail, expression ++ [head, :*])
    add ++ multiply
  end

  defp isPossible({result, values}) do
    expressions = expressions(values)

    expressions
    |> Enum.filter(fn x -> evaluate_expression(x) == result end)
    |> Enum.any?()
  end

  def evaluate_expression(expression) do
    Enum.reduce(expression, nil, fn
      x, nil -> x
      :+, acc -> {:add, acc}
      :*, acc -> {:mult, acc}
      num, {:add, acc} -> acc + num
      num, {:mult, acc} -> acc * num
    end)
  end

  defp parseLine(line) do
    parts = String.split(line, ":")

    values =
      String.split(Enum.at(parts, 1), " ")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.to_integer/1)

    result = String.to_integer(Enum.at(parts, 0))

    {result, values}
  end

  def part2(content) do
  end
end

# fileContent = File.read!("input.test.txt")
fileContent = File.read!("input.txt")
IO.puts("Part 1")
result = Day07.part1(fileContent)
IO.puts("Result: #{result} Expected: 5329")
IO.puts("Part 2")
result = Day07.part2(fileContent)
IO.puts("Result: #{result} Expected: 2162")

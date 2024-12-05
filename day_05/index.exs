defmodule Day05 do
  def part1(content) do
    parsedContent = parseContent(content)
    rules = elem(parsedContent, 0)
    rows = elem(parsedContent, 1)

    Enum.filter(rows, fn row -> isValidRow(row, rules) end)
    |> Enum.map(&getMiddleVal/1)
    |> Enum.sum()
  end

  def part2(content) do
    parsedContent = parseContent(content)
    rules = elem(parsedContent, 0)
    rows = elem(parsedContent, 1)

    Enum.filter(rows, fn row -> not isValidRow(row, rules) end)
    |> Enum.map(fn row ->
      sort(row, rules)
    end)
    |> Enum.map(&getMiddleVal/1)
    |> Enum.sum()
  end

  def sort(list, rules) do
    do_sort([], list, rules)
  end

  def do_sort(_sorted_list = [], _unsorted_list = [head | tail], rules) do
    do_sort([head], tail, rules)
  end

  def do_sort(sorted_list, _unsorted_list = [head | tail], rules) do
    insert(head, sorted_list, rules) |> do_sort(tail, rules)
  end

  def do_sort(sorted_list, _unsorted_list = [], _rules) do
    sorted_list
  end

  def insert(elem, _sorted_list = [], _) do
    [elem]
  end

  def insert(elem, sorted_list, rules) do
    [min | rest] = sorted_list

    if Enum.any?(rules, fn rule -> min == Enum.at(rule, 0) && elem == Enum.at(rule, 1) end) do
      [elem | [min | rest]]
    else
      [min | insert(elem, rest, rules)]
    end
  end

  defp getMiddleVal(row) do
    Enum.at(row, div(Enum.count(row), 2))
  end

  defp parseRows(content) do
    String.split(content, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn row ->
      String.split(row, ",") |> Enum.filter(fn x -> x != "" end) |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(fn x -> x != [] end)
  end

  defp isValidRow([val | row], rules) do
    Enum.map(row, fn value ->
      isValidPair([val, value], rules)
    end)
    |> Enum.all?(fn x -> x end) && isValidRow(row, rules)
  end

  defp isValidRow([], _) do
    true
  end

  defp isValidPair([left, right], rules) do
    Enum.any?(rules, fn rule ->
      left == Enum.at(rule, 0) && right == Enum.at(rule, 1)
    end)
  end

  defp parseContent(content) do
    parts = String.split(content, "\n\n")

    rules = parseRules(Enum.at(parts, 0))
    content = parseRows(Enum.at(parts, 1))

    {rules, content}
  end

  defp parseRules(content) do
    String.split(content, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn row ->
      String.split(row, "|")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn {value, _} -> value end)
    end)
  end
end

# fileContent = File.read!("input.test.txt")
fileContent = File.read!("input.txt")
IO.puts("Part 1")
result = Day05.part1(fileContent)
IO.puts("Result: #{result}")
IO.puts("Part 2")
result = Day05.part2(fileContent)
IO.puts("Result: #{result}")

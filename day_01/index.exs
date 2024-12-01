defmodule Day01 do
  def part1(content) do
    {left, right} = parseFile(content)
    minDistance(left, right)
  end

  def part2(content) do
    {left, right} = parseFile(content)
    sumOccurs(left, right)
  end

  defp parseFile(content) do
    String.split(content, "\n")
    |> Enum.filter(&(String.trim(&1) != ""))
    |> Enum.map(&parsePair/1)
    |> Enum.unzip()
  end

  defp sumOccurs([], _) do
    0
  end

  defp sumOccurs([head | tail], listB) do
    count = countOccurences(head, listB)
    count * head + sumOccurs(tail, listB)
  end

  defp countOccurences(val, list) do
    Enum.count(list, &(&1 == val))
  end

  defp minDistance([], []) do
    0
  end

  defp minDistance(a, b) do
    minA = Enum.min(a)
    minB = Enum.min(b)
    left = List.delete(a, minA)
    right = List.delete(b, minB)
    val = minDistance(left, right)
    abs(minA - minB) + val
  end

  defp parsePair(line) do
    [a, b] = String.split(line, "   ")
    {String.to_integer(a), String.to_integer(b)}
  end
end

# fileContent = File.read!("input_example.txt")
fileContent = File.read!("input.txt")
IO.puts("Part 1")
result = Day01.part1(fileContent)
IO.puts("Result: #{result}")
IO.puts("Part 2")
result = Day01.part2(fileContent)
IO.puts("Result: #{result}")

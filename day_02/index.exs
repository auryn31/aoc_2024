defmodule Day01 do
  def part1(content) do
    levels = parseFile(content)

    Enum.map(levels, &isSave/1)
    |> Enum.map(fn bool -> if bool, do: 1, else: 0 end)
    |> Enum.sum()
  end

  def part2(content) do
    levels = parseFile(content)

    Enum.map(levels, &isSave2/1)
    |> Enum.map(fn bool -> if bool, do: 1, else: 0 end)
    |> Enum.sum()
  end

  defp parseFile(content) do
    String.split(content, "\n")
    |> Enum.filter(&(String.trim(&1) != ""))
    |> Enum.map(&parseLevel/1)
  end

  defp parseLevel(line) do
    level = String.split(line, " ")
    Enum.map(level, &String.to_integer/1)
  end

  defp isSave(level) do
    [a, b | _] = level

    if(a > b) do
      Enum.chunk_every(level, 2, 1, :discard)
      |> Enum.map(&safePairUp/1)
      |> Enum.all?()
    else
      Enum.chunk_every(level, 2, 1, :discard)
      |> Enum.map(&safePairDown/1)
      |> Enum.all?()
    end
  end

  defp isSave2(level) do
    [a, b | _] = level

    safePairs =
      if(a > b) do
        Enum.chunk_every(level, 2, 1, :discard)
        |> Enum.map(&safePairUp/1)
      else
        Enum.chunk_every(level, 2, 1, :discard)
        |> Enum.map(&safePairDown/1)
      end

    unsafePairs =
      safePairs
      |> Enum.map(fn bool -> if bool, do: 0, else: 1 end)
      |> Enum.sum()

    if(unsafePairs == 0) do
      true
    else
      results =
        for {_, index} <- Enum.with_index(level) do
          level_without_index = Enum.reject(Enum.with_index(level), fn {_, i} -> i == index end)
          remaining_level = Enum.map(level_without_index, fn {value, _} -> value end)
          isSave(remaining_level)
        end

      Enum.any?(results)
    end
  end

  defp safePairUp(pair) do
    [first, second] = pair

    if(first > second && first - second <= 3) do
      true
    else
      false
    end
  end

  defp safePairDown(pair) do
    [first, second] = pair

    if(first < second && second - first <= 3) do
      true
    else
      false
    end
  end
end

fileContent = File.read!("input.txt")
# fileContent = File.read!("input.test.txt")
IO.puts("Part 1")
result = Day01.part1(fileContent)
IO.puts("Result: #{result}")
IO.puts("Part 2")
result = Day01.part2(fileContent)
IO.puts("Result: #{result}")

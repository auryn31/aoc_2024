defmodule Day03 do
  def part1(content) do
    multiply(content)
  end

  def part2(content) do
    updatedContent = doBuild(content)
    multiply(updatedContent)
  end

  defp multiply(content) do
    regex = ~r/mul\((\d{1,3}),(\d{1,3})\)/
    Regex.scan(regex, content) |> Enum.map(&mapResult/1) |> Enum.sum()
  end

  defp mapResult([_, x, y]) do
    String.to_integer(x) * String.to_integer(y)
  end

  defp splitDo(content) do
    content |> String.split("do()")
  end

  defp splitDont(content) do
    content |> String.split("don't()")
  end

  defp doBuild(content) do
    if(String.length(content) > 0) do
      [doS | contentDont] = splitDont(content)
      rest = Enum.join(contentDont, "don't()")
      "#{doS}#{dontBuild(rest)}"
    else
      ""
    end
  end

  defp dontBuild(content) do
    if(String.length(content) > 0) do
      [_ | contentDo] = splitDo(content)
      rest = Enum.join(contentDo, "do()")
      "#{doBuild(rest)}"
    else
      ""
    end
  end
end

fileContent = File.read!("input.txt")
# fileContent = File.read!("input.test.txt")
IO.puts("Part 1")
result = Day03.part1(fileContent)
IO.puts("Result: #{result}")
IO.puts("Part 2")
result = Day03.part2(fileContent)
IO.puts("Result: #{result}")

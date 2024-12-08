defmodule Day07 do
  def part1(content) do
    matrix =
      String.split(content, "\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&parseLine/1)

    set = toSet(matrix)
    width = Enum.count(Enum.at(matrix, 0))
    height = Enum.count(matrix)

    Enum.reduce(set, set, fn {elem, positions}, acc ->
      current = Map.get(acc, "#", [])
      toAdd = calculateAdjacent(set, {elem, positions}, width, height)
      toAddVal = Map.get(toAdd, "#", [])
      Map.put(acc, "#", current ++ toAddVal)
    end)
    |> countAntinodes()
  end

  def part2(content) do
  end

  defp countAntinodes(set) do
    antinodes = Map.get(set, "#", [])

    Enum.uniq(antinodes)
    |> IO.inspect()
    |> Enum.count()
  end

  defp calculateAdjacent(set, {elem, positions}, width, height) do
    Enum.reduce(positions, set, fn {x1, y1}, acc ->
      current = Map.get(acc, "#", [])

      toAdd =
        Enum.reduce(positions, acc, fn {x2, y2}, acc_inner ->
          if x1 != x2 or y1 != y2 do
            dx = x2 - x1
            dy = y2 - y1

            x3 = rem(x1 + 2 * dx, width)
            y3 = rem(y1 + 2 * dy, height)

            x4 = rem(x1 - dx + width, width)
            y4 = rem(y1 - dy + height, height)

            current = Map.get(acc_inner, "#", [])
            Map.put(acc_inner, "#", current ++ [{x3, y3}, {x4, y4}])
          else
            acc_inner
          end
        end)

      toAddVal = Map.get(toAdd, "#", [])
      Map.put(acc, "#", current ++ toAddVal)
    end)
  end

  defp toSet(matrix) do
    for {row, y} <- Enum.with_index(matrix),
        {elem, x} <- Enum.with_index(row),
        elem != ".",
        reduce: %{} do
      acc ->
        current = Map.get(acc, elem, [])
        Map.put(acc, elem, current ++ [{x, y}])
    end
  end

  defp parseLine(line) do
    String.split(line, "")
    |> Enum.filter(&(&1 != ""))
  end
end

fileContent = File.read!("input.test.txt")
# fileContent = File.read!("input.txt")
IO.puts("Part 1")
result = Day07.part1(fileContent)
IO.puts("Result: #{result} Expected: 14")
IO.puts("Part 2")
result = Day07.part2(fileContent)
IO.puts("Result: #{result} Expected: -")

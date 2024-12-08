defmodule Day08 do
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
    matrix =
      String.split(content, "\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&parseLine/1)

    set = toSet(matrix)
    width = Enum.count(Enum.at(matrix, 0))
    height = Enum.count(matrix)

    Enum.reduce(set, set, fn {elem, positions}, acc ->
      current = Map.get(acc, "#", [])
      toAdd = calculateAdjacent2(set, {elem, positions}, width, height)
      toAddVal = Map.get(toAdd, "#", [])
      Map.put(acc, "#", current ++ toAddVal)
    end)
    |> countAntinodes()
  end

  defp countAntinodes(set) do
    antinodes = Map.get(set, "#", [])

    Enum.uniq(antinodes)
    |> Enum.count()
  end

  defp calculateAllPointOnLine({x1, y1}, {x2, y2}, width, height) do
    m = (y2 - y1) / (x2 - x1)

    for x <- 0..(width - 1), y <- 0..(height - 1) do
      if on_line?(x1, y1, m, x, y) do
        {x, y}
      else
        nil
      end
    end
    |> Enum.filter(& &1)
  end

  defp on_line?(x1, y1, m, x, y) do
    y - y1 == m * (x - x1)
  end

  defp calculateAdjacent2(set, {_, positions}, width, height) do
    Enum.reduce(positions, set, fn {x1, y1}, acc ->
      current = Map.get(acc, "#", [])

      toAdd =
        Enum.reduce(positions, acc, fn {x2, y2}, acc_inner ->
          if x1 != x2 or y1 != y2 do
            toAdd =
              calculateAllPointOnLine({x1, y1}, {x2, y2}, width, height)

            current = Map.get(acc_inner, "#", [])
            Map.put(acc_inner, "#", current ++ toAdd)
          else
            acc_inner
          end
        end)

      toAddVal = Map.get(toAdd, "#", [])
      Map.put(acc, "#", current ++ toAddVal)
    end)
  end

  defp calculateAdjacent(set, {_, positions}, width, height) do
    Enum.reduce(positions, set, fn {x1, y1}, acc ->
      current = Map.get(acc, "#", [])

      toAdd =
        Enum.reduce(positions, acc, fn {x2, y2}, acc_inner ->
          if x1 != x2 or y1 != y2 do
            dx = x2 - x1
            dy = y2 - y1

            x3 = x2 + dx
            y3 = y2 + dy
            x4 = x1 - dx
            y4 = y1 - dy

            toAdd =
              if x3 >= 0 and x3 < width and y3 >= 0 and y3 < height do
                [{x3, y3}]
              else
                []
              end

            toAdd =
              if x4 >= 0 and x4 < width and y4 >= 0 and y4 < height do
                toAdd ++ [{x4, y4}]
              else
                []
              end

            current = Map.get(acc_inner, "#", [])
            Map.put(acc_inner, "#", current ++ toAdd)
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

# fileContent = File.read!("input.test.txt")
fileContent = File.read!("input.txt")
IO.puts("Part 1")
result = Day08.part1(fileContent)
IO.puts("Result: #{result} Expected: 396")
IO.puts("Part 2")
result = Day08.part2(fileContent)
IO.puts("Result: #{result} Expected: 1200")

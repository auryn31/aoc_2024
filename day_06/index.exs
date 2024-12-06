defmodule Day06 do
  def part1(content) do
    map = parseInput(content)
    initialPos = initialPosition(map)
    {resultMap, _} = move(map, initialPos, MapSet.new())
    countVisitedPosition(resultMap)
  end

  def part2(content) do
    originalMap = parseInput(content)
    initialPos = initialPosition(originalMap)
    {resultMap, _} = move(originalMap, initialPos, MapSet.new())

    resultMap
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      Enum.with_index(row)
      |> Enum.reduce(0, fn {elem, x}, acc ->
        if elem == "X" do
          obstracleMap =
            List.replace_at(originalMap, y, List.replace_at(Enum.at(originalMap, y), x, "#"))

          acc + isLoop(obstracleMap, initialPos)
        else
          acc
        end
      end)
    end)
    |> Enum.sum()
  end

  defp isLoop(map, pos) do
    case move(map, pos, MapSet.new()) do
      {_, :loop} -> 1
      _ -> 0
    end
  end

  defp countVisitedPosition(map) do
    Enum.reduce(map, 0, fn row, acc ->
      acc + Enum.count(Enum.filter(row, fn x -> x == "X" end))
    end)
  end

  defp parseInput(content) do
    String.split(content, "\n")
    |> Enum.map(&(String.split(&1, "") |> Enum.filter(fn x -> x != "" end)))
    |> Enum.filter(fn x -> Enum.count(x) > 0 end)
  end

  defp initialPosition(map) do
    case find_element(map, "^", :up) do
      nil -> raise "Invalid map"
      pos -> pos
    end
  end

  defp move(map, currentPosition, history) do
    if MapSet.member?(history, currentPosition) do
      {map, :loop}
    else
      history = MapSet.put(history, currentPosition)
      next = nextPosition(map, currentPosition)

      if next == nil do
        {map, :success}
      else
        map = updateMap(map, next)
        move(map, next, history)
      end
    end
  end

  defp updateMap(map, position) do
    {x, y, _} = position

    List.replace_at(map, y, List.replace_at(Enum.at(map, y), x, "X"))
  end

  defp getNexIfPossible(map, nextPos, alternative) do
    if nextPosIsOutOfMap(map, nextPos) do
      nil
    else
      if nextPosIsObstracle(map, nextPos) do
        alternative
      else
        nextPos
      end
    end
  end

  defp nextPosition(map, position) do
    {x, y, direction} = position

    case direction do
      :right ->
        getNexIfPossible(map, {x + 1, y, :right}, {x, y + 1, :down})

      :left ->
        getNexIfPossible(map, {x - 1, y, :left}, {x, y - 1, :up})

      :up ->
        getNexIfPossible(map, {x, y - 1, :up}, {x + 1, y, :right})

      :down ->
        getNexIfPossible(map, {x, y + 1, :down}, {x - 1, y, :left})
    end
  end

  defp nextPosIsObstracle(map, nexPos) do
    {x, y, _} = nexPos
    Enum.at(Enum.at(map, y), x) == "#"
  end

  defp nextPosIsOutOfMap(map, nextPos) do
    {x, y, _} = nextPos
    x < 0 || y < 0 || x >= Enum.count(Enum.at(map, 0)) || y >= Enum.count(map)
  end

  def find_element(matrix, target, direction) do
    matrix
    |> Enum.with_index()
    |> Enum.reduce_while(nil, fn {row, y}, _acc ->
      case Enum.find_index(row, fn elem -> elem == target end) do
        nil -> {:cont, nil}
        x -> {:halt, {x, y, direction}}
      end
    end)
  end
end

# fileContent = File.read!("input.test.txt")
fileContent = File.read!("input.txt")
# IO.puts("Part 1")
# result = Day06.part1(fileContent)
# IO.puts("Result: #{result} Expected: 5329")
IO.puts("Part 2")
result = Day06.part2(fileContent)
IO.puts("Result: #{result} Expected: 2162")

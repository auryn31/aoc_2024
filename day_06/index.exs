defmodule Day06 do
  def part1(content) do
    map = parseInput(content)
    initialPos = initialPosition(map)
    resultMap = move(map, initialPos)
    countVisitedPosition(resultMap) + 1
  end

  def part2(content) do
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
    right = find_element(map, ">", :right)
    left = find_element(map, "<", :left)
    top = find_element(map, "^", :top)
    down = find_element(map, "v", :down)

    if right == nil and left == nil and top == nil and down == nil do
      IO.puts("Error: Invalid map")
      exit(1)
    end

    Enum.filter([right, left, top, down], fn x -> x != nil end) |> Enum.at(0)
  end

  defp move(map, currentPosition) do
    next = nextPosition(map, currentPosition)

    if next == nil do
      map
    else
      map = updateMap(map, currentPosition)
      move(map, next)
    end
  end

  defp updateMap(map, position) do
    {x, y, _} = position

    List.replace_at(map, y, List.replace_at(Enum.at(map, y), x, "X"))
  end

  defp nextPosition(map, position) do
    {_, _, direction} = position

    case direction do
      :right ->
        {x, y, _} = position
        nextPos = {x + 1, y, :right}

        if nextPosIsOutOfMap(map, nextPos) do
          nil
        else
          if nextPosIsObstracle(map, nextPos) do
            {x, y + 1, :down}
          else
            nextPos
          end
        end

      :left ->
        {x, y, _} = position
        nextPos = {x - 1, y, :left}

        if nextPosIsOutOfMap(map, nextPos) do
          nil
        else
          if nextPosIsObstracle(map, nextPos) do
            {x, y - 1, :top}
          else
            nextPos
          end
        end

      :top ->
        {x, y, _} = position
        nextPos = {x, y - 1, :top}

        if nextPosIsOutOfMap(map, nextPos) do
          nil
        else
          if nextPosIsObstracle(map, nextPos) do
            {x + 1, y, :right}
          else
            nextPos
          end
        end

      :down ->
        {x, y, _} = position
        nextPos = {x, y + 1, :down}

        if nextPosIsOutOfMap(map, nextPos) do
          nil
        else
          if nextPosIsObstracle(map, nextPos) do
            {x - 1, y, :left}
          else
            nextPos
          end
        end
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
IO.puts("Part 1")
result = Day06.part1(fileContent)
IO.puts("Result: #{result}")
IO.puts("Part 2")
result = Day06.part2(fileContent)
IO.puts("Result: #{result}")

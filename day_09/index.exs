defmodule Day09 do
  def part1(content) do
    parseLine(content)
    |> buildStartString()
    |> String.split(";")
    |> Enum.filter(&(&1 != ""))
    |> moveNumbers()
    |> Enum.with_index()
    |> Enum.map(&toNum/1)
    |> Enum.sum()
  end

  def part2(content) do
    parseLine(content)
    |> buildStartString()
    |> String.split(";")
    |> Enum.filter(&(&1 != ""))
    |> moveParts()
    |> Enum.with_index()
    |> Enum.map(&toNum/1)
    |> Enum.sum()
  end

  defp moveParts(list) do
    leftPointer = 0
    rightPointer = Enum.count(list) - 1
    moveParts(list, leftPointer, rightPointer)
  end

  defp moveParts(list, leftPointer, rightPointer) do
    if rightPointer > leftPointer do
      leftPointer = getLeftPointer(list, leftPointer)
      rightPointer = getRightPointer(list, rightPointer)
      leftBlockSize = getBlockSize(list, Enum.at(list, leftPointer), leftPointer, 0, :forward)
      rightBlockSize = getBlockSize(list, Enum.at(list, rightPointer), rightPointer, 0, :backward)

      if leftPointer + rightBlockSize > rightPointer do
        moveParts(list, 0, rightPointer - rightBlockSize)
      else
        if leftBlockSize >= rightBlockSize do
          moveRightBlockToLeft(list, leftPointer, rightPointer, rightBlockSize)
          |> moveParts(0, rightPointer - rightBlockSize)
        else
          moveParts(list, leftPointer + leftBlockSize, rightPointer)
        end
      end
    else
      list
    end
  end

  defp moveRightBlockToLeft(list, leftPointer, rightPointer, rightBlockSize) do
    leftBegin = Enum.slice(list, 0, leftPointer)
    leftBlock = Enum.slice(list, leftPointer, rightBlockSize)

    leftEnd =
      Enum.slice(list, (leftPointer + rightBlockSize)..(rightPointer - rightBlockSize))

    rightBlock = Enum.slice(list, rightPointer - rightBlockSize + 1, rightBlockSize)

    rightEnd =
      if rightBlockSize + rightPointer >= Enum.count(list) do
        []
      else
        Enum.slice(list, (rightPointer + 1)..(Enum.count(list) - 1))
      end

    leftBegin ++ rightBlock ++ leftEnd ++ leftBlock ++ rightEnd
  end

  # defp switchElements(list, leftPointer, rightPointer) do
  #   left = Enum.at(list, leftPointer)
  #   right = Enum.at(list, rightPointer)
  #
  #   list
  #   |> List.replace_at(leftPointer, right)
  #   |> List.replace_at(rightPointer, left)
  # end

  defp moveNumbers(list) do
    leftPointer = 0
    rightPointer = Enum.count(list) - 1
    moveNumbers(list, leftPointer, rightPointer)
  end

  defp moveNumbers(list, leftPointer, rightPointer) do
    leftPointer = getLeftPointer(list, leftPointer)
    rightPointer = getRightPointer(list, rightPointer)

    if leftPointer > rightPointer do
      list
    else
      left = Enum.at(list, leftPointer)
      right = Enum.at(list, rightPointer)

      updatedList =
        list
        |> List.replace_at(leftPointer, right)
        |> List.replace_at(rightPointer, left)

      moveNumbers(updatedList, leftPointer, rightPointer)
    end
  end

  defp getRightPointer(list, rightPointer) do
    if Enum.at(list, rightPointer) == "." do
      getRightPointer(list, rightPointer - 1)
    else
      rightPointer
    end
  end

  defp getBlockSize(list, element, pointer, counter, :backward) do
    if Enum.at(list, pointer) == element do
      getBlockSize(list, element, pointer - 1, counter + 1, :backward)
    else
      counter
    end
  end

  defp getBlockSize(list, element, pointer, counter, :forward) do
    if Enum.at(list, pointer) == element do
      getBlockSize(list, element, pointer + 1, counter + 1, :forward)
    else
      counter
    end
  end

  defp getLeftPointer(list, leftPointer) do
    if Enum.at(list, leftPointer) == "." do
      leftPointer
    else
      getLeftPointer(list, leftPointer + 1)
    end
  end

  defp buildStartString(list) do
    buildStartString(list, "")
  end

  defp buildStartString([{number, idx}], acc) do
    if rem(idx, 2) == 0 do
      acc <> String.duplicate("#{Integer.floor_div(idx, 2)};", number)
    else
      acc <> String.duplicate(".;", number)
    end
  end

  defp buildStartString([head | tail], acc) do
    buildStartString([head]) <> buildStartString(tail, acc)
  end

  defp toNum({num, idx}) do
    if num == "." do
      0
    else
      String.to_integer(num) * idx
    end
  end

  defp parseLine(line) do
    line
    |> String.trim()
    |> String.split("")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
  end
end

# fileContent = File.read!("input.test.txt")
fileContent = File.read!("input.txt")
# IO.puts("Part 1")
# result = Day09.part1(fileContent)
# IO.puts("Result: #{result} Expected: 6344673854800")
IO.puts("Part 2")
result = Day09.part2(fileContent)
IO.puts("Result: #{result} Expected: 1200")

defmodule Day04 do
  def part1(content) do
    generateRows(content)
    |> Enum.filter(fn x -> String.length(x) > 3 end)
    |> Enum.map(&findMatches/1)
    |> Enum.reduce(fn x, acc -> x + acc end)
  end

  def part2(content) do
    matrix =
      String.split(content, "\n")
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.filter(fn x -> length(x) > 1 end)

    sum =
      for i <- 0..length(matrix) do
        for j <- 0..length(hd(matrix)) do
          findXmas(matrix, i, j)
        end
      end

    Enum.flat_map(sum, fn x -> x end) |> Enum.reduce(fn x, acc -> x + acc end)
  end

  defp findXmas(matrix, colIdx, rowIdx) do
    if colIdx >= length(matrix) - 2 or
         rowIdx >= length(hd(matrix)) - 2 do
      0
    else
      isA =
        Enum.at(Enum.at(matrix, colIdx + 1), rowIdx + 1) == "A" and
          Enum.at(Enum.at(matrix, colIdx), rowIdx) == "M" and
          Enum.at(Enum.at(matrix, colIdx + 2), rowIdx) == "M" and
          Enum.at(Enum.at(matrix, colIdx), rowIdx + 2) == "S" and
          Enum.at(Enum.at(matrix, colIdx + 2), rowIdx + 2) == "S"

      isB =
        Enum.at(Enum.at(matrix, colIdx + 1), rowIdx + 1) == "A" and
          Enum.at(Enum.at(matrix, colIdx), rowIdx) == "S" and
          Enum.at(Enum.at(matrix, colIdx + 2), rowIdx) == "M" and
          Enum.at(Enum.at(matrix, colIdx), rowIdx + 2) == "S" and
          Enum.at(Enum.at(matrix, colIdx + 2), rowIdx + 2) == "M"

      isC =
        Enum.at(Enum.at(matrix, colIdx + 1), rowIdx + 1) == "A" and
          Enum.at(Enum.at(matrix, colIdx), rowIdx) == "S" and
          Enum.at(Enum.at(matrix, colIdx + 2), rowIdx) == "S" and
          Enum.at(Enum.at(matrix, colIdx), rowIdx + 2) == "M" and
          Enum.at(Enum.at(matrix, colIdx + 2), rowIdx + 2) == "M"

      isD =
        Enum.at(Enum.at(matrix, colIdx + 1), rowIdx + 1) == "A" and
          Enum.at(Enum.at(matrix, colIdx), rowIdx) == "M" and
          Enum.at(Enum.at(matrix, colIdx + 2), rowIdx) == "S" and
          Enum.at(Enum.at(matrix, colIdx), rowIdx + 2) == "M" and
          Enum.at(Enum.at(matrix, colIdx + 2), rowIdx + 2) == "S"

      # IO.inspect(
      #   Enum.at(Enum.at(matrix, colIdx), rowIdx) <>
      #     "." <> Enum.at(Enum.at(matrix, colIdx), rowIdx + 2)
      # )
      #
      # IO.inspect("." <> Enum.at(Enum.at(matrix, colIdx + 1), rowIdx + 1) <> ".")
      #
      # IO.inspect(
      #   Enum.at(Enum.at(matrix, colIdx + 2), rowIdx) <>
      #     "." <> Enum.at(Enum.at(matrix, colIdx + 2), rowIdx + 2)
      # )
      # IO.inspect("")

      # Enum.at(Enum.at(matrix, colIdx + 2), rowIdx) == "M" and
      # Enum.at(Enum.at(matrix, colIdx + 2), rowIdx + 2) == "S"

      if isA or isB or isC or isD do
        1
      else
        0
      end
    end
  end

  defp generateRows(content) do
    rows = String.split(content, "\n")

    columns =
      Enum.map(0..(String.length(hd(rows)) - 1), fn i ->
        Enum.map(rows, fn x -> String.at(x, i) end)
      end)
      |> Enum.map(&Enum.join(&1, ""))

    matix = Enum.map(rows, &String.split(&1, ""))
    diagonals = find_diagonals(matix)
    rows ++ columns ++ diagonals
  end

  defp findMatches(content) do
    count(content, :xmas) + count(content, :samx)
  end

  defp count(content, :xmas) do
    regex = ~r/XMAS/
    matches = Regex.scan(regex, content)
    Enum.count(matches)
  end

  defp count(content, :samx) do
    regex = ~r/SAMX/
    matches = Regex.scan(regex, content)
    Enum.count(matches)
  end

  def find_diagonals(matrix) do
    num_rows = length(matrix)
    num_cols = length(hd(matrix))

    ltrd =
      for start <- 0..(num_rows - 1) do
        get_diagonal(matrix, {start, 0}, :ltr)
      end ++
        for start <- 1..(num_cols - 1) do
          get_diagonal(matrix, {0, start}, :ltr)
        end

    rtld =
      for start <- 0..(num_rows - 1) do
        get_diagonal(matrix, {start, num_cols - 1}, :rtl)
      end ++
        for start <- (num_cols - 2)..0 do
          get_diagonal(matrix, {0, start}, :rtl)
        end

    ltr =
      Enum.filter(ltrd, &(&1 != []))
      |> Enum.map(fn row -> Enum.join(row, "") end)

    rtl =
      Enum.filter(rtld, &(&1 != []))
      |> Enum.map(fn row -> Enum.join(row, "") end)

    ltr ++ rtl
  end

  defp get_diagonal(matrix, {row_start, col_start}, :ltr) do
    Enum.reduce_while(0..(length(matrix) + length(hd(matrix))), [], fn i, acc ->
      row = row_start + i
      col = col_start + i

      if valid_index?(matrix, row, col) do
        {:cont, acc ++ [Enum.at(Enum.at(matrix, row), col)]}
      else
        {:halt, acc}
      end
    end)
  end

  defp get_diagonal(matrix, {row_start, col_start}, :rtl) do
    Enum.reduce_while(0..(length(matrix) + length(hd(matrix))), [], fn i, acc ->
      row = row_start + i
      col = col_start - i

      if valid_index?(matrix, row, col) do
        {:cont, acc ++ [Enum.at(Enum.at(matrix, row), col)]}
      else
        {:halt, acc}
      end
    end)
  end

  defp valid_index?(matrix, row, col) do
    row < length(matrix) and row >= 0 and col < length(hd(matrix)) and col >= 0
  end
end

# fileContent = File.read!("input.test.txt")
fileContent = File.read!("input.txt")
IO.puts("Part 1")
result = Day04.part1(fileContent)
IO.puts("Result: #{result}")
IO.puts("Part 2")
result = Day04.part2(fileContent)
IO.puts("Result: #{result}")

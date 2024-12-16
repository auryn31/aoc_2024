import time

from typing import List, Tuple, Dict
import os

clear = lambda: os.system("clear")


def part1(content: str) -> int:
    (matrix, start, end) = parse_file(content)
    print_matrix(matrix, {})
    return search_finish(matrix, start, end)


def search_finish(
    matrix: List[List[str]], start: Tuple[int, int], end: Tuple[int, int]
) -> int:
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    distances: Dict[Tuple[int, int], int] = {}
    possible_points: List[Tuple[Tuple[int, int], Tuple[int, int], int]] = [
        (start, (0, 1), 0)
    ]
    current = start
    while len(possible_points) > 0:
        (current, direction, cost) = possible_points.pop(0)
        # print(f"Current: {current} - Direction: {direction} - Cost: {cost}")
        if distances.get(current) is None:
            distances[current] = cost

        for d in directions:
            cost_to_add = 1001
            if d is direction:
                cost_to_add = 1
            next_cost = cost + cost_to_add
            next_pos = (current[0] + d[0], current[1] + d[1])
            if matrix[next_pos[0]][next_pos[1]] == "#":
                continue

            if distances.get(next_pos) is None:
                possible_points.append((next_pos, d, next_cost))
                distances[next_pos] = next_cost

            if distances.get(next_pos) is None or distances[next_pos] > next_cost:
                possible_points.append((next_pos, d, next_cost))
                distances[next_pos] = next_cost
        # print_matrix(matrix, distances)
    # print(distances)
    return distances[end]


def print_matrix(matrix: List[List[str]], costs: Dict[Tuple[int, int], int]):
    clear()
    for i in range(len(matrix)):
        line = ""
        for j in range(len(matrix[i])):
            if costs.get((i, j)) is not None:
                line += str(costs[(i, j)])
            else:
                line += matrix[i][j]
        print(line)


def part2(content: str):
    print("Part 2")


def parse_file(
    content: str,
) -> Tuple[List[List[str]], Tuple[int, int], Tuple[int, int]]:
    start: Tuple[int, int] | None = None
    finish: Tuple[int, int] | None = None
    matrix = parse_matrix(content)
    for i in range(len(matrix)):
        for j in range(len(matrix[i])):
            if matrix[i][j] == "S":
                start = (i, j)
            if matrix[i][j] == "E":
                finish = (i, j)
    if start is None or finish is None:
        raise Exception(f"Start and/or finish not found in matrix #{start} #{finish}")
    return (matrix, start, finish)


def parse_matrix(content: str) -> List[List[str]]:
    matrix = []
    for line in content.split("\n"):
        if line != "":
            matrix.append(list(line))
    return matrix


if __name__ == "__main__":
    # with open("input.test.txt", "r") as file:
    #     file_content = file.read()

    with open("input.txt", "r") as file:
        file_content = file.read()
    print("Part 1")
    start = time.time()
    result = part1(file_content)
    print(f"Result: {result} in {round(time.time() - start,4)}s; Expected: 1516281")

    print("Part 2")
    start = time.time()
    result = part2(file_content)
    print(
        f"Result: {result} in {round(time.time() - start, 4)}s; Expected: 74478585072604"
    )

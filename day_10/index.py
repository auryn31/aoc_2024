import time

from typing import List, Tuple
from enum import Enum


def part1(content: str) -> int:
    matrix = parse_matrix(content)
    start_positions = get_start_positions(matrix)
    sum = 0
    for position in start_positions:
        paths = find_path(matrix, position, Option.GOALS)
        sum += paths

    return sum


def part2(content: str) -> int:
    matrix = parse_matrix(content)
    start_positions = get_start_positions(matrix)
    sum = 0
    for position in start_positions:
        paths = find_path(matrix, position, Option.PATHS)
        sum += paths

    return sum


class Option(Enum):
    PATHS = 1
    GOALS = 2


def find_path(
    matrix: List[List[int]], position: Tuple[int, int], option: Option
) -> int:
    all_positions = [position]
    current_position = 0
    while current_position < len(all_positions):
        next_possible_positions = find_next_possible_positions(
            matrix, all_positions[current_position]
        )
        if option == Option.GOALS:
            all_positions += filter_for_unseen_positions(
                all_positions, next_possible_positions
            )
        if option == Option.PATHS:
            all_positions += next_possible_positions
        current_position += 1
    return count_number(matrix, all_positions, 9)


def count_number(
    matrix: List[List[int]], positions_to_check: List[Tuple[int, int]], target: int
) -> int:
    sum = 0
    for position in positions_to_check:
        if matrix[position[0]][position[1]] == target:
            sum += 1
    return sum


def filter_for_unseen_positions(
    list: List[Tuple[int, int]], positions: List[Tuple[int, int]]
) -> List[Tuple[int, int]]:
    return [pos for pos in positions if pos not in list]


def find_next_possible_positions(
    matrix: List[List[int]], position: Tuple[int, int]
) -> List[Tuple[int, int]]:
    next_positions = []
    [left_x, left_y] = [position[0], position[1] - 1]
    [right_x, right_y] = [position[0], position[1] + 1]
    [up_x, up_y] = [position[0] - 1, position[1]]
    [down_x, down_y] = [position[0] + 1, position[1]]

    for [x, y] in [
        [left_x, left_y],
        [right_x, right_y],
        [up_x, up_y],
        [down_x, down_y],
    ]:
        if x >= 0 and x < len(matrix) and y >= 0 and y < len(matrix[0]):
            val = matrix[x][y]
            val_current = matrix[position[0]][position[1]]
            if val == val_current + 1:
                next_positions.append((x, y))
    return next_positions


def parse_matrix(content: str) -> List[List[int]]:
    matrix = []
    for line in content.split("\n"):
        if line:
            matrix.append([int(char) for char in line])

    return matrix


def get_start_positions(matrix: List[List[int]]) -> List[Tuple[int, int]]:
    start_positions = []
    for row_idx, row in enumerate(matrix):
        for col_idx, col in enumerate(row):
            if col == 0:
                start_positions.append([row_idx, col_idx])
    return start_positions


if __name__ == "__main__":
    # with open("input.test.txt", "r") as file:
    #     file_content = file.read()

    with open("input.txt", "r") as file:
        file_content = file.read()
    print("Part 1")
    start = time.time()
    result = part1(file_content)
    print(f"Result: {result} in {round(time.time() - start,4)}s; Expected: 737")

    print("Part 2")
    start = time.time()
    result = part2(file_content)
    print(
        f"Result: {result} in {round(time.time() - start, 4)}s; Expected: too high 1619"
    )

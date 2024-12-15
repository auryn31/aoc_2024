import time
import math

from typing import List, Tuple
from PIL import Image


class Robot:
    def __init__(self, pos: Tuple[int, int]):
        self.pos = pos

    def __str__(self):
        return f"Robot: {self.pos}"


def part1(content: str) -> int:
    (matrix, robot, movements) = parse_file(content)
    for movement in movements:
        (matrix, robot) = move_robot(matrix, robot, movement)
    print_area(matrix, robot)
    return calucalte_sum(matrix)


def move_robot(matrix: List[List[str]], robot: Robot, movement: str):
    if movement == ">":
        return move_direction(matrix, robot, (0, 1))
    if movement == "<":
        return move_direction(matrix, robot, (0, -1))
    if movement == "^":
        return move_direction(matrix, robot, (-1, 0))
    if movement == "v":
        return move_direction(matrix, robot, (1, 0))
    return (matrix, robot)


def move_direction(
    matrix: List[List[str]], robot: Robot, direction: Tuple[int, int]
) -> Tuple[List[List[str]], Robot]:
    [dx, dy] = direction
    new_pos = (robot.pos[0] + dx, robot.pos[1] + dy)
    next_pos_str = matrix[new_pos[0]][new_pos[1]]
    if next_pos_str == "#":
        return (matrix, robot)
    if next_pos_str == ".":
        matrix[new_pos[0]][new_pos[1]] = "@"
        matrix[new_pos[0] - dx][new_pos[1] - dy] = "."
        robot.pos = new_pos
        return (matrix, robot)
    if next_pos_str == "O":
        elements_to_move: List[Tuple[int, int]] = []
        is_movable = False
        next_pos = (new_pos[0], new_pos[1])
        while matrix[next_pos[0]][next_pos[1]] != "#":
            if matrix[next_pos[0]][next_pos[1]] == "O":
                elements_to_move.append(next_pos)
            if matrix[next_pos[0]][next_pos[1]] == "#":
                break
            if matrix[next_pos[0]][next_pos[1]] == ".":
                is_movable = True
                break
            next_pos = (next_pos[0] + dx, next_pos[1] + dy)
        if is_movable:
            to_move = elements_to_move.pop()
            matrix[to_move[0] + dx][to_move[1] + dy] = "O"
            matrix[new_pos[0]][new_pos[1]] = "@"
            matrix[new_pos[0] - dx][new_pos[1] - dy] = "."
            robot.pos = new_pos
            return (matrix, robot)
        return (matrix, robot)
    return (matrix, robot)


def print_area(matrix: List[List[str]], robot: Robot):
    for i in range(len(matrix)):
        line = ""
        for j in range(len(matrix[i])):
            if robot.pos[0] == i and robot.pos[1] == j:
                line += "@"
            else:
                line += matrix[i][j]
        print(line)


def part2(content: str, area: Tuple[int, int], itterations: int):
    print("Part 2")


def parse_file(content: str) -> Tuple[List[List[str]], Robot, List[str]]:
    robot = None
    parts = content.split("\n\n")
    matrix = parse_matrix(parts[0])
    for i in range(len(matrix)):
        for j in range(len(matrix[i])):
            if matrix[i][j] == "@":
                robot = Robot((i, j))
    if robot is None:
        raise Exception("Robot not found")
    movements = list(parts[1])
    return (matrix, robot, movements)


def parse_matrix(content: str) -> List[List[str]]:
    matrix = []
    for line in content.split("\n"):
        if line != "":
            matrix.append(list(line))
    return matrix


def calucalte_sum(matrix: List[List[str]]) -> int:
    sum = 0
    for i in range(len(matrix)):
        for j in range(len(matrix[i])):
            if matrix[i][j] == "O":
                sum += 100 * i + j
    return sum


if __name__ == "__main__":
    # with open("input.test.txt", "r") as file:
    #     file_content = file.read()
    # area = (11, 7)

    with open("input.txt", "r") as file:
        file_content = file.read()
        area = (101, 103)
    print("Part 1")
    start = time.time()
    result = part1(file_content)
    print(f"Result: {result} in {round(time.time() - start,4)}s; Expected: 1516281")

    print("Part 2")
    start = time.time()
    result = part2(file_content, area, 10000)
    print(
        f"Result: {result} in {round(time.time() - start, 4)}s; Expected: 74478585072604"
    )

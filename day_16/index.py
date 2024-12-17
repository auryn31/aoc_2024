import time

from typing import List, Set, Tuple, Dict, Self
import os
from collections import deque
import heapq


clear = lambda: os.system("clear")


def part1(content: str) -> int:
    (matrix, start, end) = parse_file(content)
    print_matrix(matrix, {})
    return search_finish(matrix, start, end)


def part2(content: str) -> int:
    (matrix, start, end) = parse_file(content)
    return seat_count(matrix, start, end)


class Node:
    def __init__(
        self,
        position: Tuple[int, int],
        cost: int,
        parent: Set[Self] | None,
        direction: Tuple[int, int],
    ):
        self.position = position
        self.cost = cost
        self.parent = parent
        self.direction = direction

    def __str__(self) -> str:
        return f"Node: {self.position} - {self.cost} - {self.direction} - {self.parent}"


def seat_count(
    matrix: List[List[str]], start: Tuple[int, int], end: Tuple[int, int]
) -> int:
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    distances: Dict[Tuple[int, int], Node] = {}
    queue: deque[Node] = deque([Node(start, 0, None, (0, 1))])
    priority_queue = []
    heapq.heappush(priority_queue, (0, Node(start, 0, set(), (0, 1))))
    while len(queue) > 0:
        current_node = queue.popleft()
        if distances.get(current_node.position) is None:
            distances[current_node.position] = current_node
        else:
            existing_node = distances[current_node.position]
            if existing_node.cost == current_node.cost:
                existing_node.parent.update(current_node.parent)
            if existing_node.cost > current_node.cost:
                distances[current_node.position] = current_node

        for d in directions:
            cost_to_add = 1001
            if d is current_node.direction:
                cost_to_add = 1
            next_cost = current_node.cost + cost_to_add
            next_pos = (
                current_node.position[0] + d[0],
                current_node.position[1] + d[1],
            )
            if matrix[next_pos[0]][next_pos[1]] == "#":
                continue

            if next_pos not in distances or distances[next_pos].cost >= next_cost:
                parent = {current_node}
                nextNode = Node(next_pos, next_cost, parent, d)
                queue.append(nextNode)

    print("Counting paths")
    result = count_paths(matrix, distances[end])
    return result


def count_paths(matrix: List[List[str]], node: Node) -> int:
    points = set()
    visited_nodes = set()
    nodeQueue = deque([node])

    while nodeQueue:
        currentNode = nodeQueue.popleft()
        if currentNode in visited_nodes:
            continue
        visited_nodes.add(currentNode)
        points.add(currentNode.position)
        if currentNode.parent:
            nodeQueue.extend(currentNode.parent)
    lines = []
    for i in range(len(matrix)):
        line = ""
        for j in range(len(matrix[i])):
            if (i, j) in points:
                line += "O"
            else:
                line += matrix[i][j]
        lines.append(line)
    clear()
    print("\n".join(lines))
    return len(points)


def print_path(matrix: List[List[str]], path: Set[Tuple[int, int]]):
    clear()
    for i in range(len(matrix)):
        line = ""
        for j in range(len(matrix[i])):
            if (i, j) in path:
                line += "O"
            else:
                line += matrix[i][j]
        print(line)


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
                continue

            if distances[next_pos] > next_cost:
                possible_points.append((next_pos, d, next_cost))
                distances[next_pos] = next_cost
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
    print(f"Result: {result} in {round(time.time() - start,4)}s; Expected: 11048")

    print("Part 2")
    start = time.time()
    result = part2(file_content)
    print(f"Result: {result} in {round(time.time() - start, 4)}s; Expected: 498")

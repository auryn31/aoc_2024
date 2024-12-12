import time

from typing import List, Tuple


def part1(content: str) -> int:
    matrix = parse_matrix(content)
    regions = []
    seen = set()
    for i in range(len(matrix)):
        for j in range(len(matrix[i])):
            if (i, j) in seen:
                continue
            target = matrix[i][j]
            region = get_region(matrix, (i, j), [], target)
            sorted = sort_region(region)
            for pos in sorted:
                seen.add(pos)
            if len(sorted) > 0 and not region_exists(sorted, regions):
                regions.append(sorted)
    sum = 0
    for region in regions:
        sum = sum + area(region) * perimeter(region)
    return sum


def part2(content: str) -> int:
    matrix = parse_matrix(content)
    regions = []
    seen = set()
    for i in range(len(matrix)):
        for j in range(len(matrix[i])):
            if (i, j) in seen:
                continue
            target = matrix[i][j]
            region = get_region(matrix, (i, j), [], target)
            sorted = sort_region(region)
            for pos in sorted:
                seen.add(pos)
            if len(sorted) > 0 and not region_exists(sorted, regions):
                regions.append(sorted)
    sum = 0
    for region in regions:
        sum = sum + area(region) * calculate_corners(region)
    return sum


def area(region: List[Tuple[int, int]]) -> int:
    return len(region)


def perimeter(region: List[Tuple[int, int]]) -> int:
    sum = 0
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    for pos in region:
        for dx, dy in directions:
            if (pos[0] + dx, pos[1] + dy) not in region:
                sum = sum + 1
    return sum


def calculate_corners(region: List[Tuple[int, int]]) -> int:
    corners = 0
    for x, y in region:
        # Top-left corner
        # Inside corner
        if (
            (x - 1, y) in region
            and (x, y - 1) in region
            and not (x - 1, y - 1) in region
        ):
            corners += 1

        # Outside corner
        if not (x - 1, y) in region and not (x, y - 1) in region:
            corners += 1

        # Top-right corner
        # Inside corner
        if (
            (x + 1, y) in region
            and (x, y - 1) in region
            and not (x + 1, y - 1) in region
        ):
            corners += 1

        # Outside corner
        if not (x + 1, y) in region and not (x, y - 1) in region:
            corners += 1

        # Bottom-left corner
        # Inside corner
        if (
            (x - 1, y) in region
            and (x, y + 1) in region
            and not (x - 1, y + 1) in region
        ):
            corners += 1

        # Outside corner
        if not (x - 1, y) in region and not (x, y + 1) in region:
            corners += 1

        # Bottom-right corner
        # Inside corner
        if (
            (x + 1, y) in region
            and (x, y + 1) in region
            and not (x + 1, y + 1) in region
        ):
            corners += 1

        # Outside corner
        if not (x + 1, y) in region and not (x, y + 1) in region:
            corners += 1

    return corners


def region_exists(
    region: List[Tuple[int, int]], regions: List[List[Tuple[int, int]]]
) -> bool:
    return any(region == r for r in regions)


def sort_region(region: List[Tuple[int, int]]) -> List[Tuple[int, int]]:
    return sorted(region, key=lambda x: (x[0], x[1]))


def parse_matrix(content: str) -> List[List[str]]:
    matrix = [[char for char in line] for line in content.split("\n")]
    return [line for line in matrix if len(line) > 0]


def get_region(
    matrix: List[List[str]],
    start: Tuple[int, int],
    region: List[Tuple[int, int]],
    target: str,
) -> List[Tuple[int, int]]:
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    updated_region = region + [start]
    for dx, dy in directions:
        if continue_search(
            matrix, (start[0] + dx, start[1] + dy), target, updated_region
        ):
            updated_region = get_region(
                matrix, (start[0] + dx, start[1] + dy), updated_region, target
            )
    return updated_region


def continue_search(
    matrix: List[List[str]],
    next: Tuple[int, int],
    target: str,
    region: List[Tuple[int, int]],
) -> bool:
    return (
        is_in_matrix(matrix, next[0], next[1])
        and matrix[next[0]][next[1]] == target
        and next not in region
    )


def is_in_matrix(matrix: List[List[str]], x: int, y: int) -> bool:
    return x >= 0 and y >= 0 and x < len(matrix) and y < len(matrix[0])


if __name__ == "__main__":
    # with open("input.test.txt", "r") as file:
    #     file_content = file.read()

    with open("input.txt", "r") as file:
        file_content = file.read()
    print("Part 1")
    start = time.time()
    result = part1(file_content)
    print(f"Result: {result} in {round(time.time() - start,4)}s; Expected: 1361494")

    print("Part 2")
    start = time.time()
    result = part2(file_content)
    print(f"Result: {result} in {round(time.time() - start, 4)}s; Expected: 830516")

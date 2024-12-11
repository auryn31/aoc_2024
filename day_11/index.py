import time

from typing import List, Tuple
from enum import Enum


def part1(content: str) -> int:
    return value_after_blinks(content, 25)


def handle_number(num: int) -> List[int]:
    if num == 0:
        return [1]

    digits = len(str(num))
    if digits % 2 == 0:
        arr = list(str(num))
        right = arr[: len(arr) // 2]
        left = arr[len(arr) // 2 :]
        return [int(("").join(left)), int(("").join(right))]
    return [num * 2024]


def part2(content: str) -> int:
    return value_after_blinks(content, 75)


def value_after_blinks(content: str, blinks: int) -> int:
    numbers = parse_line(content)
    for _ in range(blinks):
        new_numbers = {}
        for num, count in numbers.items():
            nextNumber = handle_number(num)
            for n in nextNumber:
                if n in new_numbers:
                    new_numbers[n] = new_numbers[n] + count
                else:
                    new_numbers[n] = count

        numbers = new_numbers

    sum = 0
    for _, v in numbers.items():
        sum = sum + v
    return sum


def parse_line(content: str) -> dict[int, int]:
    map = {}
    for num in [int(char) for char in content.split(" ")]:
        map[num] = 1
    return map


if __name__ == "__main__":
    # with open("input.test.txt", "r") as file:
    #     file_content = file.read()

    with open("input.txt", "r") as file:
        file_content = file.read()
    print("Part 1")
    start = time.time()
    result = part1(file_content)
    print(f"Result: {result} in {round(time.time() - start,4)}s; Expected: 189092")

    print("Part 2")
    start = time.time()
    result = part2(file_content)
    print(
        f"Result: {result} in {round(time.time() - start, 4)}s; Expected: 224869647102559"
    )

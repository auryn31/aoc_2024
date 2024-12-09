import time

from typing import List

def part1(content: str) -> int:
    parts = parse_line(content)
    start_string = build_start_string(parts)
    parts = [p for p in start_string.split(";") if p]
    updated = move_numbers(parts)
    return sum(to_num(num, idx) for idx, num in enumerate(updated))


def part2(content: str) -> int:
    parts = parse_line(content)
    start_string = build_start_string(parts)
    parts = [p for p in start_string.split(";") if p]
    updated = move_parts(parts)
    return sum(to_num(num, idx) for idx, num in enumerate(updated))



def move_parts(parts: List[str]) -> List[str]:
    left_pointer = 0
    right_pointer = len(parts) - 1

    while left_pointer < right_pointer:
        left_pointer = get_left_pointer(parts, left_pointer)
        right_pointer = get_right_pointer(parts, right_pointer)

        left_block_size = get_block_size(parts, parts[left_pointer], left_pointer, direction="forward")
        right_block_size = get_block_size(parts, parts[right_pointer], right_pointer, direction="backward")

        if left_pointer > right_pointer :
            right_pointer -= right_block_size
            left_pointer = 0
        else:
            if left_block_size >= right_block_size:
                parts = move_right_block_to_left(parts, left_pointer, right_pointer, right_block_size)
                right_pointer -= right_block_size
                left_pointer = 0
            else:
                left_pointer += left_block_size

    return parts


def move_numbers(parts: List[str]) -> List[str]:
    left_pointer = 0
    right_pointer = len(parts) - 1

    while left_pointer < right_pointer:
        left_pointer = get_left_pointer(parts, left_pointer)
        right_pointer = get_right_pointer(parts, right_pointer)

        if left_pointer >= right_pointer:
            break

        # Swap numbers
        parts[left_pointer], parts[right_pointer] = parts[right_pointer], parts[left_pointer]

        # Move inward
        left_pointer += 1
        right_pointer -= 1

    return parts


def move_right_block_to_left(parts: List[str], left_pointer: int, right_pointer: int, right_block_size: int) -> List[str]:
    left_begin = parts[:left_pointer]
    left_block = parts[left_pointer:left_pointer + right_block_size]
    left_end = parts[left_pointer + right_block_size:right_pointer - right_block_size + 1]
    right_block = parts[right_pointer - right_block_size + 1:right_pointer + 1]
    right_end = parts[right_pointer + 1:]

    return left_begin + right_block + left_end + left_block + right_end


def get_left_pointer(parts: List[str], left_pointer: int) -> int:
    while left_pointer < len(parts) and parts[left_pointer] != ".":
        left_pointer += 1
    return left_pointer


def get_right_pointer(parts: List[str], right_pointer: int) -> int:
    while right_pointer >= 0 and parts[right_pointer] == ".":
        right_pointer -= 1
    return right_pointer


def get_block_size(parts: List[str], element: str, pointer: int, direction: str) -> int:
    size = 0
    step = 1 if direction == "forward" else -1

    while 0 <= pointer < len(parts) and parts[pointer] == element:
        size += 1
        pointer += step

    return size


def build_start_string(parts: List[tuple]) -> str:
    result = []
    for number, idx in parts:
        if idx % 2 == 0:
            result.append(f"{idx // 2};" * number)
        else:
            result.append(".;" * number)
    return "".join(result)


def to_num(num: str, idx: int) -> int:
    return 0 if num == "." else int(num) * idx


def parse_line(line: str) -> List[tuple]:
    return [(int(c), i) for i, c in enumerate(line.strip()) if c.isdigit()]


# Example usage
if __name__ == "__main__":
    with open("input.txt", "r") as file:
        file_content = file.read()

    # with open("input.test.txt", "r") as file:
    #     file_content = file.read()
    print("Part 1")
    start = time.time()
    result = part1(file_content)
    print(f"Result: {result} in {time.time() - start}s; Expected: 6344673854800")

    print("Part 2")
    start = time.time()
    result = part2(file_content)
    print(f"Result: {result} in {time.time() - start}s; Expected: too high 6360363631231")

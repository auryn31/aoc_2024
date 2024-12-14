import time
import math

from typing import List, Tuple
from PIL import Image


class Robot:
    def __init__(self, pos: Tuple[int, int], velocity: Tuple[int, int]):
        self.pos = pos
        self.velocity = velocity

    def __str__(self):
        return f"Robot: {self.pos} {self.velocity}"

    def move(self, area: Tuple[int, int]):
        [width, height] = area
        [x, y] = (self.pos[0] + self.velocity[0], self.pos[1] + self.velocity[1])
        x = (x + width) % width
        y = (y + height) % height
        self.pos = (x, y)


def part1(content: str, area: Tuple[int, int]) -> int:
    robots = parse_file(content)
    for _ in range(100):
        for robot in robots:
            robot.move(area)

    quadrants = count_in_quadrant(robots, area)
    print(quadrants)
    sum = quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3]
    return sum


def print_area(robots: List[Robot], area: Tuple[int, int]):
    [width, height] = area
    area = [["." for x in range(width)] for y in range(height)]
    for robot in robots:
        area[robot.pos[1]][robot.pos[0]] = "#"
    for row in area:
        print("".join(row))


def draw_image(robots: List[Robot], area: Tuple[int, int], itteration: int):
    [width, height] = area
    im = Image.new("RGB", (width, height), (255, 255, 255))
    for robot in robots:
        im.putpixel(robot.pos, (0, 0, 0))
    im.save(f"images/image_#{itteration}.png")


def part2(content: str, area: Tuple[int, int], itterations: int):
    robots = parse_file(content)
    for i in range(itterations):
        for robot in robots:
            robot.move(area)
        draw_image(robots, area, i + 1)


def quadrant_size(area: int) -> int:
    if area % 2 == 0:
        return int(area / 2) - 1
    return math.floor(area / 2)


def count_in_quadrant(robots: List[Robot], area: Tuple[int, int]) -> List[int]:
    quadrants = [0, 0, 0, 0]
    [width, height] = (quadrant_size(area[0]), quadrant_size(area[1]))
    for robot in robots:
        if robot.pos[0] < width and robot.pos[1] < height:
            quadrants[0] += 1
        if robot.pos[0] < width and robot.pos[1] > height:
            quadrants[1] += 1
        if robot.pos[0] > width and robot.pos[1] < height:
            quadrants[2] += 1
        if robot.pos[0] > width and robot.pos[1] > height:
            quadrants[3] += 1
    return quadrants


def parse_file(content: str) -> List[Robot]:
    robots = []
    for robot in content.split("\n"):
        if robot != "":
            robots.append(parse_robot(robot))
    return robots


def parse_robot(line: str) -> Robot:
    parts = line.split(" ")
    pos_parts = parts[0].split("=")
    pos = (int(pos_parts[1].split(",")[0]), int(pos_parts[1].split(",")[1]))
    velo_parts = parts[1].split("=")
    velo = (int(velo_parts[1].split(",")[0]), int(velo_parts[1].split(",")[1]))
    return Robot(pos, velo)


if __name__ == "__main__":
    # with open("input.test.txt", "r") as file:
    #     file_content = file.read()
    #     area = (11,7)

    with open("input.txt", "r") as file:
        file_content = file.read()
        area = (101, 103)
    print("Part 1")
    start = time.time()
    result = part1(file_content, area)
    print(f"Result: {result} in {round(time.time() - start,4)}s; Expected: 208437768")

    print("Part 2")
    start = time.time()
    result = part2(file_content, area, 10000)
    print(
        f"Result: {result} in {round(time.time() - start, 4)}s; Expected: 74478585072604"
    )

import time

from typing import List, Tuple


class Game:
    def __init__(
        self, buttonA: Tuple[int, int], buttonB: Tuple[int, int], prize: Tuple[int, int]
    ):
        self.buttonA = buttonA
        self.buttonB = buttonB
        self.prize = prize

    def __str__(self):
        return f"Game: {self.buttonA} {self.buttonB} {self.prize}"


def calculate_game(game: Game) -> Tuple[float, float]:
    a = (game.prize[1] * game.buttonB[0] - game.buttonB[1] * game.prize[0]) / (
        game.buttonA[1] * game.buttonB[0] - game.buttonB[1] * game.buttonA[0]
    )
    b = (game.prize[0] - game.buttonA[0] * a) / game.buttonB[0]
    return a, b


def part1(content: str) -> int:
    games = parse_file(content)
    sum = 0
    for game in games:
        [a, b] = calculate_game(game)
        if a.is_integer() and b.is_integer():
            sum += a * 3 + b
    return int(sum)


def part2(content: str) -> int:
    games = parse_file(content)
    sum = 0
    for game in games:
        to_add = 10000000000000
        newGame = Game(
            game.buttonA, game.buttonB, (game.prize[0] + to_add, game.prize[1] + to_add)
        )
        [a, b] = calculate_game(newGame)
        if a.is_integer() and b.is_integer():
            sum += a * 3 + b
    return int(sum)


def parse_file(content: str) -> List[Game]:
    games = []
    for game in content.split("\n\n"):
        games.append(parse_game(game))
    return games


def parse_game(content: str) -> Game:
    lines = content.split("\n")
    buttonA = parse_button(lines[0])
    buttonB = parse_button(lines[1])
    prize = parse_price(lines[2])
    return Game(buttonA, buttonB, prize)


def parse_button(line: str) -> Tuple[int, int]:
    parts = line.split(": ")[1].split(",")
    x = int(parts[0].split("+")[1])
    y = int(parts[1].split("+")[1])
    return x, y


def parse_price(line: str) -> Tuple[int, int]:
    parts = line.split(": ")[1].split(",")
    x = int(parts[0].split("=")[1])
    y = int(parts[1].split("=")[1])
    return x, y


if __name__ == "__main__":
    # with open("input.test.txt", "r") as file:
    #     file_content = file.read()

    with open("input.txt", "r") as file:
        file_content = file.read()
    print("Part 1")
    start = time.time()
    result = part1(file_content)
    print(f"Result: {result} in {round(time.time() - start,4)}s; Expected: 39748")

    print("Part 2")
    start = time.time()
    result = part2(file_content)
    print(
        f"Result: {result} in {round(time.time() - start, 4)}s; Expected: 74478585072604"
    )

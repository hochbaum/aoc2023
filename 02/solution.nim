import tables
import regex
import strutils
import sequtils
import math

let maxCubes = {"red": 12, "green": 13, "blue": 14}.toTable

type Game = object
    id: int
    bags: seq[Table[string, int]]

proc parseGame(line: string): Game =
    let
        idRegex = re2"Game\s(\d+):"
        id = line[line.findAll(idRegex)[0].group(0)].parseInt
        bags = line.split(re2";")
        cubeRegex = re2"(\d+)\s(blue|red|green)(,|;|$)"

    var t: seq[Table[string, int]] = @[]
    for i in 0 .. bags.len - 1:
        t.add(initTable[string, int]())
        for match in bags[i].findAll(cubeRegex):
            let
                amount = bags[i][match.group(0)].parseInt
                color = bags[i][match.group(1)]
            t[i][color] = t[i].getOrDefault(color, 0) + amount

    result = Game(
        id: id,
        bags: t,
    )

proc isInvalid(game: Game): bool =
    # Please tell me how to use map and any on these ;(
    for bag in game.bags:
        for color, amount in maxCubes:
            if bag.getOrDefault(color, 0) > amount:
                return true
    
    result = false

proc prod(self: seq[int]): int =
    for i in self:
        if result == 0: result = 1
        result *= i

proc calcPower(game: Game): int =
    var maxes = initTable[string, int]()
    for bag in game.bags:
        for color, amount in bag:
            maxes[color] = max(maxes.getOrDefault(color, 0), amount)
            
    result = maxes.values().toSeq().prod()       

let 
    games = readFile("./02/input.txt")
        .splitLines()
        .map(parseGame)
    possibleSum = games.filter(proc (g: Game): bool = not g.isInvalid())
        .map(proc (g: Game): int = g.id)
        .sum()
    minPowers = games.map(calcPower).sum()

echo "Part 1 result: ", possibleSum
echo "Part 2 result: ", minPowers
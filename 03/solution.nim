import regex
import strutils
import sequtils
import math
import tables

type 
    Symbol = object
        x: int
        y: int
        val: char
    Number = object
        x1: int
        y1: int
        x2: int
        y2: int
        val: int

proc parseSymbols(lines: seq[string]): seq[Symbol] =
    result = newSeq[Symbol]()
    for row in 0 ..< lines.len:
        for col in 0 ..< lines[row].len:
            let c = lines[row][col]
            if ($c).match(re2"[^\d.]"):
                result &= Symbol(
                    x: col, 
                    y: row, 
                    val: lines[row][col]
                )

proc parseNumbers(lines: seq[string]): seq[Number] =
    result = newSeq[Number]()
    for row in 0 ..< lines.len:
        for match in lines[row].findAll(re2"(\d+)"):
            let g = match.group(0)
            result &= Number( 
                x1: g.a, 
                y1: row, 
                x2: g.b, 
                y2: row, 
                val: lines[row][g].parseInt
            )

proc distance2d(x1: int, y1: int, x2: int, y2: int): int =
    result = abs(int(sqrt(toFloat(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2)))))

proc doCollideWith(syms: seq[Symbol], num: Number): bool =
    result = false
    for sym in syms:
        for i in num.x1 .. num.x2:
            if distance2d(i, num.y1, sym.x, sym.y) < 2:
                return true

# could all be refactored ;/
proc collides(sym: Symbol, num: Number): bool =
    result = false
    for i in num.x1 .. num.x2:
        if distance2d(i, num.y1, sym.x, sym.y) < 2:
            return true

proc group(syms: seq[Symbol], nums: seq[Number]): Table[Symbol, seq[Number]] =
    result = initTable[Symbol, seq[Number]]()
    for sym in syms:
        for n in nums:
            if sym.collides(n):
                result[sym] = result.getOrDefault(sym, @[]) & n

            
proc findCollisions(syms: seq[Symbol], nums: seq[Number]): seq[int] =
    result = @[]
    for n in nums:
        if syms.doCollideWith(n):
            result &= n.val
                
let 
    input = readFile("./03/input.txt").splitlines()
    nums = parseNumbers(input)
    syms = parseSymbols(input)
    colls = findCollisions(syms, nums)

echo "Part 1 solution: " & $(colls.sum())

var total = 0
for k, v in syms.group(nums):
    if v.len == 2:
        total += v[0].val * v[1].val

echo "Part 2 solution: " $total

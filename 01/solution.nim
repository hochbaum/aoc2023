import math
import re
import strutils
import std/sequtils

let words = [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
]

proc wordToDigit(str: string): string =
    let index = find(words, str)
    result = 
        if index == -1: # Feeling lazy today
            str
        else:
            $(index + 1) 

proc calcLine(line: string, withWords: bool): int =
    let
        regex = 
            if withWords:
                 re"\d|one|two|three|four|five|six|seven|eight|nine"
            else:
                 re"\d"
        matches = findAll(line, regex)
            .map(wordToDigit)

    result = (matches[0] & matches[^1]).parseInt

let 
    lines = readFile("./01/input.txt").splitlines()
    withoutWords = lines.map(proc (line: string): int = calcLine(line, false)).sum()
    withWords = lines.map(proc (line: string): int = calcLine(line, true)).sum()

echo "Part 1 result: " & $withoutWords
echo "Part 2 result: " & $withWords
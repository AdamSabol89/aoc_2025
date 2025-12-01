package day1
import "core:fmt"
import s "core:strings"
import conv "core:strconv"

parse_line :: proc(input: string) -> (turns: int) {
    assert(len(input) >= 2, "input guaranteed to have turn direction and amount")
    dir : int
    switch input[0] {
        case 'L': 
            dir = -1
        case 'R': 
            dir = 1
        case:
            assert(false, "first string element should be L/R")
    }
    turns = (conv.atoi(input[1:]) * dir)
    return
}

wrapping_arithmetic :: proc(x: int, m: int) -> int {
    return ((x % m) + m) % m
}

mod_100_arithmetic :: proc(x: int) -> int {
    return wrapping_arithmetic(x, 100)
}

solve :: proc(input: ^string) -> (silver: int, gold: int) {
    state := 50

    for line in s.split_lines_iterator(input) {
        turns := parse_line(s.trim_space(line))
        ir := state + turns

        rotations := abs(ir / 100)
        if ir <=0 && state != 0  {
            rotations += 1
        }

        state = mod_100_arithmetic(ir)
        if state == 0 do silver += 1
        gold += rotations
    }

    return
}

main :: proc() { 
    trimmed := s.trim_space(input)
    result_silver, result_gold := solve(&trimmed)
    fmt.printfln("Silver result %d, Gold result %d", result_silver, result_gold)
}


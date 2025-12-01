package day1
import "core:fmt"
import s "core:strings"
import conv "core:strconv"

Dir :: enum { 
    LEFT,
    RIGHT
}
Turns :: int

parse_line :: proc(input: string) -> (dir: Dir, turns: Turns) {
    assert(len(input) >= 2, "input guaranteed to have turn direction and amount")

    switch input[0] {
        case 'L': 
            dir = .LEFT
        case 'R': 
            dir = .RIGHT
        case:
            assert(false, "first string element should be L/R")
    }

    turns = conv.atoi(input[1:])
    return
}

wrapping_arithmetic :: proc(x: int, m: int) -> int {
    return ((x % m) + m) % m
}

mod_100_arithmetic :: proc(x: int) -> int {
    return wrapping_arithmetic(x, 100)
}

solve1 :: proc(input: ^string) -> (silver_result: int, gold_result: int) {
    state := 50

    for line in s.split_lines_iterator(input) {
        dir, turns := parse_line(s.trim_space(line))

        switch(dir) {
            case .LEFT: 
                val := state - turns
                if val < 0 {
                    gold_result += 1 
                    gold_result += -(val / 100)
                }

                state = mod_100_arithmetic(val)
            case .RIGHT:
                val := state + turns
                gold_result += val/100
                state = mod_100_arithmetic(val)
        }

        if state == 0 do silver_result += 1;
    }

    return
}

main :: proc() { 
    trimmed := s.trim_space(test_input)
    result_silver, result_gold := solve1(&trimmed)
    fmt.printfln("Silver result %d, Gold result %d", result_silver, result_gold)
}


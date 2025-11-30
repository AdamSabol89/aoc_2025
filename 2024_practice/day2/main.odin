package day2

import "core:slice"
import "core:sort"
import "core:fmt"
import s "core:strings"
import conv "core:strconv"

parse_point :: proc(inp: string, out: ^[dynamic]int)  { 
    val := conv.atoi(s.trim(inp, " \n"))
    append(out, val)
}

parse_line :: proc(inp: string) -> []int {
    ret_vals := make([dynamic]int, 0, 8, context.temp_allocator)
    vals := s.split(inp, " ")

    for val in vals {
        parse_point(val, &ret_vals)
    }

    return ret_vals[:]
}

parse_lines :: proc(inp: ^string) -> [][]int{ 
    lines :[dynamic][]int = make([dynamic][]int, 0)
    for line in s.split_lines_iterator(inp) {
        parsed_line := parse_line(line)
        append(&lines, parsed_line)
    }
    return lines[:]
}

validate_report :: proc(inp: []int) -> (bool, int) {
    x := -1 if inp[0] > inp[1] else 1

    for i:= 0 ; (i + 1) < len(inp); i += 1 {
        j := i + 1

        if !(inp[i] * x < inp[j] * x ) {
            return false, j
        }

        if abs(inp[i] - inp[j]) > 3 {
            return false, j
        }
    }

    return true, -999
}

main :: proc() { 
    defer free_all(context.temp_allocator)

    vals := make([dynamic]int, 0, 8, context.temp_allocator)
    trimmed := s.trim_space(input_1)

    lines := parse_lines(&trimmed)

    result := 0

    for line in lines { 
       ok, bad_idx := validate_report(line)
        if ok {
            result += 1
        } else {
            ok, _ := validate_report(line[1:])
            if ok {
                result += 1
                continue
            } 

            slices_1 := [][]int{ line[0:bad_idx], line[bad_idx + 1:] } 
            slices_2 := [][]int{ line[0:bad_idx-1], line[bad_idx:] } 

            new := slice.concatenate(slices_1) 
            new_2 := slice.concatenate(slices_2) 

            ok, _ = validate_report(new)
            if ok {
                result += 1
                continue
            } 

            ok, _ = validate_report(new_2)
            if ok do result += 1
        }

    }

    fmt.println(result)
}

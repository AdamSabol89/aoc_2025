package day1

import "core:fmt"
import "core:sort"
import conv "core:strconv"
import s "core:strings"

sort_int :: proc(arr: ^[]int) {
	it := sort.slice_interface(arr)
	sort.sort(it)
}

parse_points :: proc(inp: string, out: ^[dynamic]int) {
	val := conv.atoi(s.trim(inp, " \n"))
	append(out, val)

}

input_to_arrs :: proc(input: string) -> ([]int, []int) {
	left: [dynamic]int
	right: [dynamic]int

	for line in s.split_lines(input) {
		points := s.split(line, "   ")
		if (len(points) != 2) do continue
		parse_points(points[0], &left)
		parse_points(points[1], &right)
	}
	return left[:], right[:]
}

solve1 :: proc(input: string) -> int {
	left, right := input_to_arrs(input)

	sort_int(&left)
	sort_int(&right)

	result: int = 0

	for i := 0; i < len(right); i += 1 {
		result += abs(left[i] - right[i])
	}

	return result
}

solve2 :: proc(input: string) -> int {
	left, right := input_to_arrs(input)
	right_map: map[int]int

	for val in right {
		old := right_map[val]
		old += 1
		right_map[val] = old
	}

	result := 0
	for val in left {
		factor := right_map[val]
		result += (val * factor)
	}

	return result
}

main :: proc() {
	day1 := solve2(input_1)
	day2 := solve2(input_1)

	fmt.printfln("Solution for day 1 part 1: %d", day1)
	fmt.printfln("Solution for day 1 part 2: %d", day2)
}

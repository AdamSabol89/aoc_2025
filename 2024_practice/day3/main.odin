package day3 
/* 
   This is not finished and is really half of an implementation? 
*/ 
import "core:slice"
import pq "core:container/priority_queue"
import "core:sort"
import "core:fmt"
import s "core:strings"
import conv "core:strconv"

Cheat :: struct {
    positions: [2]Pos,
    cheat_length: int, 
    distance_to_cheat: Distance, 
    distance_to_end_cheat: Distance,
    distance_to_end: Distance,
}

Distance :: int
UP : [2]int : [2]int{-1, 0}
DOWN : [2]int : [2]int{1, 0}
LEFT : [2]int : [2]int{0, -1}
RIGHT : [2]int : [2]int{0, 1}

WALL : int : 35 
TRACK : int : 46
START : int : 83
END : int : 69
DIRS : [][2]int : [][2]int{UP,DOWN,LEFT,RIGHT}

RaceTrack :: [][]int
Pos :: [2]int

parse_line :: proc(inp: string) -> []int {
    ret_vals := make([dynamic]int, 0, context.temp_allocator)

    for char in inp {
        append(&ret_vals, cast(int) char)
    }

    return ret_vals[:]
}

parse_lines :: proc(inp: ^string) -> RaceTrack { 
    lines :[dynamic][]int = make([dynamic][]int, 0)
    for line in s.split_lines_iterator(inp) {
        parsed_line := parse_line(line)
        append(&lines, parsed_line)
    }
    return lines[:]
}

// Used to find Start/End.
find :: proc(track: RaceTrack, target: int) -> Pos {
    for line, i in track { 
        for point, j in line {
            if target == point do return [2]int{i,j}
        }
    }

    assert(false, "Unable to find target in racetrack")
    return [2]int{-1,-1}
}

index_is :: proc(track: RaceTrack, pos: Pos, target: int) -> bool {
    if (pos[0] < len(track) && pos[1] < len(track[0])) && pos[0] >= 0 && pos[1] >= 0
    {
        if track[pos[0]][pos[1]] == target do return true 

    }
    return false
}

/*
if index_is(track, new_pos, WALL) {

    new_pos = Pos{new_pos[0] + dir[0], new_pos[1] + dir[1] }

    if index_is(track, new_pos, WALL) {
        final := Pos{new_pos[0] + dir[0], new_pos[1] + dir[1] }

        fmt.println(pos, final)
        if index_is(track, final, TRACK) {
            cheat := Cheat {
                positions = [2]Pos{pos, new_pos}
            }
            return cheat
        }

    }
}
*/
continue_in_dir :: proc(pos: Pos, dir: [2]int ) -> Pos {
    ret_pos := Pos{pos[0] + dir[0], pos[1] + dir[1] }
    return ret_pos
}

cheats: map[Cheat]struct{}

determine_cheats :: proc(track: RaceTrack, start_pos: Pos, cur_pos: Pos, input_dir: [2]int, length: int){
    for dir in DIRS { 
        if dir == (input_dir * -1) {
            continue
        }

        end_pos := continue_in_dir(cur_pos, dir)

        if index_is(track, end_pos, TRACK){
            
            new_cheat := Cheat { 
                positions = [2]Pos{start_pos, end_pos},
                cheat_length = length
            }

            cheats[new_cheat] = struct{}{}
        }

    }
}

cheat_from_point :: proc(track: RaceTrack, pos: Pos) {
    if index_is(track, pos, TRACK){
        for dir in DIRS { 

            continue_pos := continue_in_dir(pos, dir)
            if index_is(track, continue_pos, WALL){
                determine_cheats(track, pos, continue_pos, dir, 1)
            } else do continue

            continue_pos = continue_in_dir(continue_pos, dir)
            if index_is(track, continue_pos, WALL) {
                determine_cheats(track, pos, continue_pos, dir, 2)
            }

        }
    }

}

get_cheats :: proc(track: RaceTrack) {
    for line, i in track { 
        for point, j in line {
            pos := Pos{i, j}
            cheat_from_point(track, pos)
        }
    }
}

solve1 :: proc(inp: ^string) {
    track := parse_lines(inp)

    start_pos := find(track, START)
    end_pos := find(track, END)

    get_cheats(track)
}

path_to_end :: proc(track: RaceTrack, start: Pos, end: Pos) {
    queue: pq.Priority_Queue(struct{pos:Pos, seconds: int, dir: [2]int})
}

main :: proc() {
    inp := s.trim_space(input_1)
    solve1(&inp) 
}

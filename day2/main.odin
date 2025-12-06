package day2
import "core:fmt"
import "core:os"
import conv "core:strconv"
import s "core:strings"

solve :: proc(input: ^string) -> (silver: int, gold: int) {
    for range in s.split_iterator(input, ",") {
        splits := s.split(range,  "-", context.temp_allocator)
        assert(len(splits) == 2)

        begin := conv.atoi(splits[0])
        end := conv.atoi(splits[1])

        for i in begin ..= end {
            buf : [1000]u8
            str_rep := conv.itoa(buf[:], i)
            half := len(str_rep) / 2

            if str_rep[0:half] == str_rep[half:] {
                silver += i
            }

            for j in 1 ..= len(str_rep) / 2 {
                fmt.println(str_rep[0:j], "part one", str_rep[j:j+j])
                if (str_rep[0:j] == str_rep[j:j+j]) {
                    gold += i
                }
            }
        }
    }
    return
}

test_input: string = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

main :: proc() {
    silver, gold := solve(&test_input)
    fmt.println(silver, gold)
}


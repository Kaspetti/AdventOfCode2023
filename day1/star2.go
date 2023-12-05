package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)


func main() {
    fmt.Printf("Solution to star two: %v\n", startwo())
}


func startwo() int {
    f, err := os.Open("input")
    if err != nil {
        log.Fatal(err)
    }
    defer f.Close()

    scanner := bufio.NewScanner(f)
    strNums := []string{"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}

    nums := make([]int, 0)
    for scanner.Scan() {
        num1, num2 := -1, -1
        line := scanner.Text()

        strnum := ""

        // Start searching from the beginning to find the first number
        forward:
        for _, r := range line {
            // Check if rune is a digit between 0 and 9
            if r >= 48 && r <= 57 {
                // Convert from unicode to integer representation
                num1 = int(r) - 48
                break
            }

            // Check if the currently checked string contains any of the words for numbers
            strnum += string(r)
            for n, sn := range strNums {
                if strings.Index(strnum, sn) != -1 {
                    num1 = n + 1
                    break forward
                }
            }
        }

        strnum = ""

        // Start searching from the end to find the last number
        backward:
        for i := len(line)-1; i >= 0; i-- {
            r := line[i]
            // Check if rune is a digit between 0 and 9
            if r >= 48 && r <= 57 {
                // Convert from unicode to integer representation
                num2 = int(r) - 48
                break
            }

            // Check if the currently checked string contains any of the words for numbers
            strnum = string(r) + strnum
            for n, sn := range strNums {
                if strings.Index(strnum, sn) != -1 {
                    num2 = n + 1
                    break backward
                }
            }
        }

        // Concatenate the numbers by multiplying the first by ten and then adding the remaining
        nums = append(nums, (num1 * 10) + num2)
    }

    total := 0
    for _, num := range nums {
        total += num
    }

    return total
}

package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)


func main() {
    fmt.Printf("Solution to star one: %v", starone())
}


func starone() int {
    f, err := os.Open("input")
    if err != nil {
        log.Fatal(err)
    }
    defer f.Close()

    scanner := bufio.NewScanner(f)

    nums := make([]int, 0)
    for scanner.Scan() {
        num1, num2 := -1, -1
        line := scanner.Text()

        for _, r := range scanner.Text() {
            // Check if rune is a digit between 0 and 9
            if r >= 48 && r <= 57 {
                // Convert from unicode to integer representation
                num1 = int(r) - 48
                break
            }
        }

        for i := len(line)-1; i >= 0; i-- {
            r := line[i]
            // Check if rune is a digit between 0 and 9
            if r >= 48 && r <= 57 {
                // Convert from unicode to integer representation
                num2 = int(r) - 48
                break
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


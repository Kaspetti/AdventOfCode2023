package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)


func main() {
    f, err := os.Open("input")
    if err != nil {
        log.Fatal(err)
    }
    defer f.Close()

    scanner := bufio.NewScanner(f)

    nums := make([]int, 0)
    for scanner.Scan() {
        num1, num2 := ' ', ' '

        for _, r := range scanner.Text() {
            // Check if rune is a digit between 0 and 9
            if r >= 48 && r <= 57 {
                if num1 == ' ' {
                    num1 = r - 48
                }             
                num2 = r - 48
            }
        }

        nums = append(nums, (int(num1) * 10) + int(num2))
    }

    total := 0
    for _, num := range nums {
        total += num
    }

    fmt.Println(total)
}

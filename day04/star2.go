package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)


func main() {
    f, err := os.Open("input")
    if err != nil {
        log.Fatal(err)
    }
    defer f.Close()

    scanner := bufio.NewScanner(f)
    copies := make(map[int]int)

    currentCard := 1
    for scanner.Scan() {
        line := scanner.Text()
        numbers := strings.Split(strings.Split(line, ": ")[1], " | ")

        winningNumbers := strings.Split(numbers[0], " ")
        ourNumbers := strings.Split(numbers[1], " ")
        
        if _, ok := copies[currentCard]; ok {
            copies[currentCard]++
        } else {
            copies[currentCard] = 1
        }

        winningNumberCount := 0
        for _, number := range winningNumbers {
            if number == "" {
                continue
            }

            if contains(ourNumbers, number) {
                winningNumberCount++

                if _, ok := copies[currentCard + winningNumberCount]; ok {
                    copies[currentCard + winningNumberCount] += copies[currentCard]
                } else {
                    copies[currentCard + winningNumberCount] = copies[currentCard]
                }
            }
        }

        currentCard++
    }

    totalCards := 0
    for _, v := range copies {
        totalCards += v
    }

    fmt.Println(totalCards)
}


func contains[K comparable](ls []K, e K) bool {
    for _, e_ls := range ls {
        if e_ls == e {
            return true
        } 
    }

    return false
}

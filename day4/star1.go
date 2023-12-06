package main


import (
    "os"
    "bufio"
    "fmt"
    "log"
    "strings"
)


func main() {
    f, err := os.Open("input")
    if err != nil {
        log.Fatal(err)
    }
    defer f.Close()

    scanner := bufio.NewScanner(f)
    totalScore := 0

    for scanner.Scan() {
        line := scanner.Text()
        numbers := strings.Split(strings.Split(line, ": ")[1], " | ")

        winningNumbers := strings.Split(numbers[0], " ")
        ourNumbers := strings.Split(numbers[1], " ")
        currentScore := 0
        for _, number := range winningNumbers {
            if number == "" {
                continue
            }

            if contains(ourNumbers, number) {
                if currentScore == 0 {
                    currentScore = 1
                    continue
                }

                currentScore *= 2
            }
        }

        totalScore += currentScore
    } 

    fmt.Println(totalScore)
}


func contains[K comparable](ls []K, e K) bool {
    for _, e_ls := range ls {
        if e_ls == e {
            return true
        } 
    }

    return false
}


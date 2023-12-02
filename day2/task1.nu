let games = (open input | lines)

let max_red = 12
let max_green = 13
let max_blue = 14

mut total = 0

for game in $games {
    mut too_many = false
    let game_rounds = ($game | split column ": " Game Rounds)
    let game_id = (($game_rounds.Game | split column " " _ Id).Id | get 0 | into int)

    let rounds = ($game_rounds.Rounds | split row "; ")

    for round in $rounds {
        let hands = ($round | split row ", ")

        for hand in $hands {
            let amount_color = ($hand | split column " " Amount Color)

            let color = ($amount_color.Color | get 0)
            let amount = ($amount_color.Amount | get 0)

            if $color == "green" {
                if ($amount | into int) > $max_green {
                    $too_many = true
                    break
                }
            } else if $color == "red" {
                if ($amount | into int) > $max_red {
                    $too_many = true
                    break
                }
            } else if $color == "blue" {
                if ($amount | into int) > $max_blue {
                    $too_many = true
                    break
                }
            }
        }

        if $too_many == true {
            break
        }
    }

    if $too_many == false {
        $total += $game_id
    }
} 

print $total

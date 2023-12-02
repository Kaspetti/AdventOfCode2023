let games = (open input | lines)

mut total = 0

for game in $games {
    let game_rounds = ($game | split column ": " Game Rounds)
    let game_id = (($game_rounds.Game | split column " " _ Id).Id | get 0 | into int)

    let rounds = ($game_rounds.Rounds | split row "; ")

    mut min_green = 0
    mut min_red = 0
    mut min_blue = 0

    for round in $rounds {
        let hands = ($round | split row ", ")

        for hand in $hands {
            let amount_color = ($hand | split column " " Amount Color)

            let color = ($amount_color.Color | get 0)
            let amount = (($amount_color.Amount | get 0) | into int)

            if $color == "green" {
                if $amount > $min_green {
                    $min_green = $amount
                }
            } else if $color == "red" {
                if $amount > $min_red {
                    $min_red = $amount
                }
            } else if $color == "blue" {
                if $amount > $min_blue {
                    $min_blue = $amount
                }
            }
        }
    }

    $total += ($min_green * $min_red * $min_blue)
} 

print $total

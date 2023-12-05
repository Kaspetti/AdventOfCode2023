let games = (open input | lines)

let max_colors = {
    "red":12
    "green":13
    "blue":14
}

mut total = 0

for game in $games {
    let game_rounds = ($game | split column ": " Game Rounds)
    let hands = ($game_rounds.Rounds | split row -r "[,;]+")
    let game_id = (($game_rounds.Game | split column " " _ Id).Id | get 0 | into int)
    mut too_many = false

    for hand in $hands {
        let amount_color = ($hand | str trim | split column " " Amount Color)
        let amount = ($amount_color.Amount | get 0 | into int)
        let color = ($amount_color.Color | get 0)

        if $amount > ($max_colors | get $color) {
            $too_many = true
            break
        }
    }

    if not $too_many {
        $total += $game_id
    }
}

print $total

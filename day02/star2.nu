let games = (open input | lines)

mut total = 0

for game in $games {
    let game_rounds = ($game | split column ": " Game Rounds)
    let hands = ($game_rounds.Rounds | split row -r "[,;]+")
    let game_id = (($game_rounds.Game | split column " " _ Id).Id | get 0 | into int)

    mut min_colors = {
        "red":0
        "green":0
        "blue":0
    }

    for hand in $hands {
        let amount_color = ($hand | str trim | split column " " Amount Color)
        let amount = ($amount_color.Amount | get 0 | into int)
        let color = ($amount_color.Color | get 0)

        if $amount > ($min_colors | get $color) {
            $min_colors = ($min_colors | merge {$color:$amount})
        }
    }

    $total += $min_colors."red" * $min_colors."green" * $min_colors."blue"
}

print $total

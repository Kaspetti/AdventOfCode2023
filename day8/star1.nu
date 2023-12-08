let input = (open "input" | split column "\n\n" Directions Map)

let directions = $input.Directions | get 0 | split row ""
let maps_list = $input.Map | get 0 | split row "\n"


# Create maps record
mut maps_record = {}

for map in $maps_list {
    if $map == "" {
        continue
    }

    let start_target = $map | split row " = "

    let left_right = $start_target | get 1 | str replace '(' '' | str replace ')' '' | split row ", "
    let left = $left_right | get 0
    let right = $left_right | get 1
    let start = $start_target | get 0

    $maps_record = ($maps_record | merge {$start:{"L":$left, "R":$right}})
}


mut location = "AAA"
mut steps = 0
mut i = 0; loop {
    if $i >= ($directions | length) - 1 {
        $i = 0
    }

    let direction = $directions | get $i
    if $direction == "" {
        $i += 1
        continue
    }

    $steps += 1
    let destination = $maps_record | get $location | get $direction
    if $destination == "ZZZ" {
        break
    }

    $location = $destination
    $i += 1
}


print $steps

let input = (open "input" | split column "\n\n" Directions Map)

let directions = $input.Directions | get 0 | split chars
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


mut start_locations = ($maps_record | columns | where {|k| $k | str ends-with "A" })
mut steps = []

mut cur_location = ""
for start_location in $start_locations {
    print ("Checking " + $start_location)
    mut step = 0
    $cur_location = $start_location
    mut i = 0; loop {
        if $i > ($directions | length) - 1 {
            $i = 0
        }

        let direction = $directions | get $i
        let destination = $maps_record | get $cur_location | get $direction

        $step += 1
        $i += 1

        if ($destination | str ends-with "Z") {
            break
        }

        $cur_location = $destination
    }

    $steps = ($steps | append $step)
}

mut lcm = $steps | get 0
mut i = 1; loop {
    if $i > ($steps | length) - 1 {
        break
    }

    let $step = ($steps | get $i)
    mut gcd = ([$lcm, $step] | math min)
    loop {
        if $gcd <= 0 {
            break
        }

        if $step mod $gcd == 0 and $lcm mod $gcd == 0 {
            break
        }
        $gcd -= 1
    }

    $lcm = (($lcm * $step) / $gcd)

    $i += 1
}

print $lcm

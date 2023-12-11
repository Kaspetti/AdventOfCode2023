let input = (open input) 
let table = ($input | split column "\n\n" Seeds SeedToSoil SoilToFert FertToWater WaterToLight LightToTemp TempToHumid HumidToLoc)


let seeds = ($table.Seeds | split row " " | range 1..)

let maps = [
    ($table.SeedToSoil | split row "\n" | range 1..),
    ($table.SoilToFert | split row "\n" | range 1..),
    ($table.FertToWater | split row "\n" | range 1..),
    ($table.WaterToLight | split row "\n" | range 1..),
    ($table.LightToTemp | split row "\n" | range 1..),
    ($table.TempToHumid | split row "\n" | range 1..),
    ($table.HumidToLoc | split row "\n" | range 1..)
]


mut locations = []
for seed in $seeds {
    let seed = $seed | into int

    mut stepNumber = $seed
    for map in $maps {
        for range in $map {
            if $range == "" {
                continue
            }

            let rt = ($range | split row " ")
            let destination = ($rt | get 0 | into int)
            let source = ($rt | get 1 | into int)
            let length = ($rt | get 2 | into int)
            
            if $stepNumber >= $source and $stepNumber < $source + $length {
                $stepNumber = $destination + ($stepNumber - $source)
                break
            }
        }
    }

    $locations = ($locations | append $stepNumber)
}

print ($locations | math min)

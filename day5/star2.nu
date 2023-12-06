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


mut minLocation = -1
mut minSeed = -1
mut i = 0; loop {
    print ("Approximating Pairing " + ($i | into string))
    if $i > ($seeds | length) - 1 { break }

    let lengthIndex = $i + 1
    let start = ($seeds | get $i | into int)
    let length = ($seeds | get $lengthIndex | into int)
    let end = $start + $length

    let sqrt = ($end | math sqrt | into int)

    mut n = 0; loop {
        if ($start + $n) >= $end - 1 {
            break
        }

        let $seed = $start + $n

        print (($seed | into string) + " of " + ($end | into string))

        mut $stepNumber = $seed
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

        $n += $sqrt
        if $stepNumber < $minLocation or $minLocation == -1 {
            $minLocation = $stepNumber
            $minSeed = $seed
        }
    }

    $i += 2
}

$minLocation = -1
mut i = 0; loop {
    print ("Anaylyzing Pairing " + ($i | into string))
    if $i > ($seeds | length) - 1 { break }

    let lengthIndex = $i + 1
    let start = ($seeds | get $i | into int)
    let length = ($seeds | get $lengthIndex | into int)
    let end = $start + $length

    let sqrt = ($end | math sqrt | into int)

    $i += 2

    if $minSeed < $start or $minSeed >= $end {
        let start = $minSeed - $sqrt
        let end = $minSeed

        for seed in $start..$end {
            print (($seed | into string) + " of " + ($end | into string))

            mut $stepNumber = $seed
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
            if $stepNumber < $minLocation or $minLocation == -1 {
                $minLocation = $stepNumber
            }
        }
        break
    }
}

print $minLocation 


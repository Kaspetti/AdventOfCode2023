use std::fs;

fn main() {
    let contents = fs::read_to_string("input")
        .expect("Could not read file");

    let lines = contents.split('\n').collect::<Vec<&str>>();

    let time_line = lines[0]
                    .split(' ')
                    .filter(|&c| c != "")
                    .collect::<Vec<&str>>();

    let time = &time_line[1..].join("").parse::<i64>().unwrap();


    let distance_line = lines[1]
                        .split(' ')
                        .filter(|&c| c != "")
                        .collect::<Vec<&str>>();

    let distance_record = &distance_line[1..].join("").parse::<i64>().unwrap(); 
                        

    let mut total_records = 0;
    let middle: i64 = time / 2;

    let mut step: i64 = 0;
    loop {
        // Check above
        let remaining_time = time - (middle + step);
        let speed = middle + step;
        let distance = remaining_time * speed;

        if i64::from(distance) > *distance_record {
            total_records += 1;
        } else {
            break;
        }

        step += 1;
    }

    step = -1;
    loop {
        // Check below
        let remaining_time = time - (middle + step);
        let speed = middle + step;
        let distance = remaining_time * speed;

        if i64::from(distance) > *distance_record {
            total_records += 1;
        } else {
            break;
        }

        step -= 1;
    }

    println!("{total_records}");
}

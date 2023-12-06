use std::{fs, collections::VecDeque};

fn main() {
    let contents = fs::read_to_string("input")
        .expect("Could not read file");

    let lines = contents.split('\n').collect::<Vec<&str>>();

    let mut times = lines[0]
                    .split(' ')
                    .filter(|&c| c != "")
                    .collect::<VecDeque<&str>>();
    times.pop_front();

    let mut distances = lines[1]
                        .split(' ')
                        .filter(|&c| c != "")
                        .collect::<VecDeque<&str>>();
    distances.pop_front();
                        

    let mut product_records = 1;
    for i in 0..times.len() {
        let mut total_records = 0;

        let total_time = times[i].parse::<i32>().unwrap();
        let distance_record = distances[i].parse::<i32>().unwrap();

        for j in 0..total_time {
            let remaining_time = total_time - j;
            let distance = remaining_time * j;

            if distance > distance_record {
                total_records += 1;
            }
        }

        product_records *= total_records;
    }

    println!("{product_records}")
}

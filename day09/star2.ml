let process_line values = 
  let rec get_diffs ls diffs = 
    match ls with
    | [] -> List.rev diffs
    | _::[] -> List.rev diffs
    | x::y::xs -> 
        get_diffs (y::xs) ((y-x):: diffs);
  in
  let rec trace_steps steps =
    let diffs = get_diffs (List.hd steps) [] in
    if List.for_all (fun ele -> ele = 0) diffs then
      steps
    else
      trace_steps (diffs::steps)
  in
  let steps = trace_steps [values] in
  let rec extrapolate_history target steps =
    match steps with
    | [] -> target
    | x::xs ->
        let num = List.hd x in
        extrapolate_history (num - target) xs
  in
  extrapolate_history 0 steps


let rec process_lines ic sum =
  try
    let line =  input_line ic in
    let values = List.map (int_of_string) (String.split_on_char ' ' line) in
    process_lines ic (sum + process_line values)
  with 
    | End_of_file ->
        close_in ic;
        sum
    | e ->
        close_in_noerr ic;
        raise e


let main file =
  let ic = open_in file in
  let result = process_lines ic 0 in
  print_int result

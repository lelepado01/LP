type freq = {word : string ; mutable frequency : int }

let rec increase_freq = fun c l ->
    match l with
    | [] -> Printf.printf "Fine Lista"
    | x::xs when x.word = c -> x.frequency <- (x.frequency+1)
    | x::xs -> increase_freq c xs;;

let new_freq = fun w f ->
    {word=w; frequency=f};;

let print_freq = fun freq ->
    (Printf.printf "%s " freq.word; Printf.printf "%i\n" freq.frequency);;


let frequency_array = [];; 
let rec process_file = fun file frequency_array ->
    let rec process_line = fun ls f_arr -> 
        match ls with
        | [] -> frequency_array
        | x::xs -> 
            if List.exists (fun w -> if w.word=x then true else false) f_arr then
                (increase_freq x f_arr; process_line xs f_arr)
            else 
                process_line xs (List.cons (new_freq x 1) f_arr)
    in
    try
        (process_line (Str.split (Str.regexp " ") (read_line file)) frequency_array ; process_file file frequency_array)
    with End_of_file -> (List.iter (print_freq) frequency_array; None );; 



let file_path = "data.txt";;
let file = open_in file_path;;

process_file file frequency_array;;

close_in file;;

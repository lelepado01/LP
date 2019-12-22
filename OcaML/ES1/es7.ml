
let operation = fun op e1 e2 ->
    match op with
    | "*" -> e1 *. e2
    | "+" -> e1 +. e2
    | "-" -> e1 -. e2
    | "/" -> e1 /. e2
    | _-> -1.0;;

let process_string = fun str ->
    let stack = Stack.create () in
    let rec aux_proc = fun ls ->
        match ls with
        | [] -> Stack.pop stack
        | x::xs when Str.string_match (Str.regexp "[+*-/]") x 0 -> 
            (Stack.push (operation x (Stack.pop stack) (Stack.pop stack)) stack ; aux_proc xs)
        | x::xs -> (Stack.push (float_of_string x) stack ; aux_proc xs)
    in
    let op_list = Str.split (Str.regexp " ") str in
    (aux_proc op_list);;

let res = process_string "4 5 7 + - 7 + 12 /";;
Printf.printf "%f" res;;
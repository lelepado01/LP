
let succ = fun x -> x+1;;

let x = succ 4;;

(*Printf.printf "%i" x;;
*)

let funfunc = fun x ->
    match x with
    | 0 -> 1
    | 12 -> 2
    | 1 -> 3
    | _ -> 4;;

Printf.printf "%i" (funfunc 1);;
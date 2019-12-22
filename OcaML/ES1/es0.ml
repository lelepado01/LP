let ls0 = [1;2;3;4;5];;
let ls1 = [1;2;2;4;5;6;5];;

let rec count = fun l ->
    match l with
    | [] -> 0
    | x::xs -> 1 + count xs;;

(*Printf.printf "%d" (count ls) ;; *)


let rec zip_longest = fun ls0 ls1 ->
    match (ls0, ls1) with
    | ([],[]) | (_, []) | ([], _) -> []
    | (y0::ys0, y1::ys1) -> [(y0, y1)]::zip_longest ys0 ys1;;

zip_longest ls0 ls1;;

let rec enumerate = fun num ls ->
    match ls with
    | [] -> []
    | x::xs -> [(num, x)]::enumerate (num+1) xs;;

(*List.iter (Printf.printf "%d") (enumerate 0 ls1);;*)


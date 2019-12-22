
let ls = [1;2;3;4;5];;

let rec count ls = fun ->
    match ls with
    | [] -> 0
    | x::xs -> 1 + count xs

let rec zip_longest ls1 ls2 = fun ->
    match () with
    | ([], []) | ([], _) | ([],_) -> []
    | (x::xs, y::ys) -> [(x,y)]::zip_longest xs ys

let rec pairwise ls = fun ->
    | 
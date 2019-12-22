

let aem = [12 ; 4 ; 20 ; 56; 38 ; 88];;

let rec max = fun ls -> 
    match ls with
    | [] -> 0
    | x :: xs -> 
        if max xs >= x then max xs else x;;

(*let x = max aem;;
Printf.printf "%i" x;;*)

let rec sort = fun ls ->
    match ls with
    | [] -> []
    | x :: [] -> x :: []
    | x1 :: x2 :: xs -> 
        if x1 >= x2 then 
            x2 :: x1 :: (sort xs)
        else 
            x1 :: x2 :: (sort xs);;


let rec print = fun ls ->
    match ls with
    | [] -> print_string "\n"
    | x :: xs -> Printf.printf "%i" x ; print_string " " ; print xs;;

print aem;; 

let sorted = sort aem;;

print sorted;;
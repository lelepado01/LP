
let isPrime = fun n ->
    let rec checkPrime = fun n i checked_list ->
        let rec list_contains_mult = fun i ls ->
            match ls with
            | [] -> false
            | x::xs when i mod x=0 -> true
            | x::xs -> list_contains_mult i xs
        in
        if i < (n/2) then
            if list_contains_mult i checked_list then
                checkPrime n (i+1) checked_list
            else 
                if n mod i = 0 then 
                    false
                else
                    checkPrime n (i+1) (i::checked_list)
        else 
            true
    in
    checkPrime n 2 [];;


let goldbach_list = fun n ->
    let rec iterate = fun n i found_list->
        if i < n / 2 then
            let c = n - i in
            if (isPrime c) && (isPrime i) then
                iterate n (i+1) ((i,c)::found_list)
            else
                iterate n (i+1) found_list
        else
            found_list
    in 
    iterate n 1 [];;


let goldbach = fun n ->
    let x = goldbach_list n in
    match x with
    | [] -> (-1, -1)
    | x::xs -> x

let rec print_list = fun ls ->
    match ls with
    | [] -> Printf.printf ""
    | (x,y)::xs -> (Printf.printf "%i, %i\n" x y ; print_list xs);; 

let rec print_tuple = fun t->
    match t with
    | (x,y) -> Printf.printf "%i,%i\n" x y;;

print_tuple (goldbach 16);;

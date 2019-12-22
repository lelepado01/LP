
let alkaline_earth_metals = [4;12;20;38;56;88];;

let shuffled_aem = [88;12;4;20;56;38];;

let rec get_max_atomic_num = fun max ls ->
    match ls with
    | [] -> max
    | x::xs ->  if x > max then 
                    get_max_atomic_num x xs
                else 
                    get_max_atomic_num max xs;;

(*Printf.printf "%i" (get_max_atomic_num 0 alkaline_earth_metals);;*)

let compare = fun x y -> if x > y then 1 else if x = y then 0 else -1;;
(*
List.iter (Printf.printf "%i ") (List.sort compare shuffled_aem);;
*)

let noble_gases = [2;10;18;36;54;86];;

let noble_gases_names = ["helium";"neon";"argon";"krypton";"xenon";"radon"];;


let compare_couple = fun (x, _) (y, _) ->
    if x > y then 1
    else if x = y then 0
    else -1;;

let rec merge = fun l1 l2 -> 
    match (l1, l2) with
    | ([],_) | (_,[]) -> []
    | (x::xs, y::ys) -> (x,y)::merge xs ys;;

let merge_and_sort = fun ls1 ls2 ->
    List.sort compare_couple (merge ls1 ls2 );;

(*merge_and_sort noble_gases noble_gases_names;;*)



(*
let rec fact = fun n ->
    if n > 0.0 then
        n *. fact (n -. 1.0)
    else
        1.0;;

let sin = fun x n ->
    let appr = List.init n (fun i -> ((x ** (2 * i + 1) /. (fact (2 * n +1))))) in
    let rec calc_appr = fun i acc ls ->
        match ls with 
        | [] -> acc
        | x::xs when i %. 2 = 0 -> calc_appr (i+1) (acc -. x) xs 
        | x::xs -> calc_appr (i+1) (acc +. x) xs 
    in
    x + (calc_appr 0.0 0.0 appr);;

    *)

open Operation
open Sin

module Test(O : Operation.Operation) = 
struct 
    let x = O.op 3.0 3.0
end

module M0 = Test(Sin);;

Printf.printf "%f" M0.x;;
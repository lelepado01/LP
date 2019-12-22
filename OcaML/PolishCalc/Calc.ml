open IntegerStack

module type Calculator = 
sig
    type expr
    type exp_list = expr list

    val expr_of_string : string -> exp_list
    val eval : exp_list -> int
end
module Calculator : Calculator= 
struct
    type expr = Value of int | Operator of char
    type exp_list = expr list

    let eval = fun exp_ls ->
        let stack = IntegerStack.empty() in
        let rec aux_eval = fun exp st ->
            match exp with
            | [] -> IntegerStack.top st
            | x::xs -> 
                match x with
                | Value _ -> (IntegerStack.push x stack ; aux_eval xs st)
                | Operator _ -> 
                    let x = 
        in
        aux_eval exp_ls stack;;
end
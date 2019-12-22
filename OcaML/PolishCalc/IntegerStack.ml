open StackI

module IntegerStack : StackI = 
struct
    type tp = int
    type stack = {mutable stack : tp list}

    exception Stack_is_empty

    let empty () = []

    let int_to_type = fun x -> x

    let type_to_int = fun x -> x

    let push = fun n s ->
        match s with
        | [] -> s.stack <- n::[]
        | x::xs -> s.stack <- n::x::xs

    let pop = fun s ->
        match s with
        | [] -> raise Stack_is_empty
        | x::xs -> (s.stack <- xs ; x)

    let top = fun s ->
        match s with
        | [] -> raise Stack_is_empty
        | x::xs -> x
end
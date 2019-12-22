module type Graph =
sig
    type 'a graph

    val empty : 'a graph
    val isEmpty : 'a graph -> bool
    val addNode : 'a -> 'a graph -> 'a graph
    val addEdge : 'a -> 'a -> 'a graph -> 'a graph

end

module Graph = 
struct

    type 'a graph = Graph of
        ('a list) * (('a * 'a) list)

    let empty = Graph([], [])

    let isEmpty = fun g ->
        match g with
        | Graph([], _) -> true
        | _ -> false

    let addNode = fun n g ->
        let rec add_to_list = fun n ls ->
            match ls with
            | [] -> n::[]
            | x::xs when x=n -> x::xs
            | x::xs -> x::(add_to_list n xs)
        in
        match g with
        | Graph([], e) -> Graph(n::[], e)
        | Graph( xs , e) -> Graph (add_to_list n xs , e)

        
    let addEdge = fun n1 n2 g -> 
        let rec add_to_list = fun n1 n2 ls ->
            match ls with
            | [] -> (n1, n2)::[]
            | (x1, x2)::xs when ((x1=n1 && x2=n2) || (x1=n2 && x2=n1)) -> (x1, x2)::xs
            | x::xs -> x::(add_to_list n1 n2 xs)
        in
        match g with
        | Graph(n, []) -> Graph(n, (n1, n2)::[])
        | Graph( n, xs) -> Graph (n, add_to_list n1 n2 xs)

end
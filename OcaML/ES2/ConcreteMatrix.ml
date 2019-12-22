open Matrix

module ConcreteMatrix : Matrix =
struct 
    type 'a matrix = 'a array array

    exception Illegal_size of string

    let create = fun n m -> 
        Array.make_matrix n m 0

    let copy = fun mat -> mat

    let equivalence = fun m1 m2 ->
        let rec checkRows = fun r1 r2 ->
            match (r1, r2) with
            | ([], []) -> true::[]
            | (_, []) | ([], _) -> false::[]
            | (r1::rs1, r2::rs2) -> (r1=r2)::checkRows rs1 rs2
        in
        let b_ls = Array.map2 (fun x y -> List.fold_left (&&) true (checkRows (Array.to_list x) (Array.to_list y))) m1 m2 in
        Array.fold_left ( && ) true b_ls


    let addition = fun m1 m2 -> 
        let 

    let scalar_mult = fun s mat -> mat

    let mat_mult = fun m1 m2 -> m1
end

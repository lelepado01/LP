open Operation

module Sin : Operation = 
struct

    let rec fact = fun n ->
    if n > 0.0 then
        n *. fact (n -. 1.0)
    else
        1.0;;

    let list_init = fun n f ->
        let rec create_list = fun n f i ls ->
            if i < n then
                create_list n f (i +. 1.0) ((f i)::ls)
            else
                ls
        in
        create_list n f 0.0 [];;

    let op = fun x n ->
        let appr = list_init n (fun i -> ((x ** (2.0 *. i +. 1.0) /. (fact (2.0 *. n +. 1.0))))) in
        let rec calc_appr = fun i acc ls ->
            match ls with 
            | [] -> acc
            | x::xs when i mod 2 = 0 -> calc_appr (i+1) (acc -. x) xs 
            | x::xs -> calc_appr (i+1) (acc +. x) xs 
        in
        x +. (calc_appr 0 0.0 appr);;

end
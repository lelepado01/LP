module type Matrix = 
sig
    type 'a matrix

    val zeros : int -> int -> int matrix
    val identity : int -> int matrix
    val init : int -> int matrix
    val transpose : int matrix -> int matrix
    val ( * ) : int matrix -> int matrix -> int matrix
    val print_matrix : int matrix -> unit

end

module ArrayMatrix : Matrix = 
struct

    exception Invalid_Argument of string

    type 'a matrix = 'a array array

    let zeros = fun n m ->
        Array.make_matrix n m 0

    let identity = fun n -> 
        let mat = zeros n n
        in
        let rec fill_diag = fun i ->
            if i = n then mat
            else (mat.(i).(i) <- 1; fill_diag (i+1))
        in fill_diag 0 

    let init = fun n ->
        let mat = zeros n n
        in  let fill_row = fun i row ->
            Array.iteri (fun x r -> row.(x) <- (i * n)+x) row
        in Array.iteri fill_row mat; mat

    let size = fun m ->
            (Array.length m, Array.length m.(0)) 

    let get_skeleton = fun x y ->
        zeros x y

    let transpose = fun mat ->
        let x, y = size mat in
        let transposed = get_skeleton x y in
        
        let t_row = fun row_index row -> 
            Array.iteri (fun x r -> transposed.(x).(row_index) <- r) row
        in 
        (Array.iteri t_row mat; transposed)

    let get_column = fun col mat ->
        let vec = Array.make (Array.length mat.(0)) 0 in
        (Array.iteri (fun i v -> vec.(i) <- mat.(i).(col)) vec; vec)

    let ( * ) = fun mat1 mat2 ->
        let x1, y1 = size mat1 in
        let x2, y2 = size mat2 in
        if (x1, y1) <> (x2, y2) then
            raise (Invalid_Argument " * ")
        else
            let sum_of_prod = fun vec1 vec2 ->
                (Array.iteri (fun i v -> vec1.(i) <- vec1.(i) + v ) vec2; 
                 Array.fold_left (fun x y -> x + y) vec1)
            in
            let sk = get_skeleton y1 x2 in
            Array.iteri (fun i x -> sk.().() <- sum_of_prod x (get_column i mat2)) mat1 
            
            (*
                sum_of_prod restituisce somma dei prodotti di vettore riga per colonna
                iteri su riga di mat1, poi iteri su colonna di mat2 -> chiamando sumofprod
                    con i rispettivi vettori
                Tutto quello va messo in sk.(i).(j)
                E va restituito sk
            *)


    let print_matrix = fun mat -> 
        let print_row = fun r ->
            (Array.iter (Printf.printf "%i ") r ; Printf.printf "\n")
        in  Array.iter (print_row) mat



    (*
    let test = zeros 2 3;;
    print_matrix test;;
    let ident = identity 4;;
    print_matrix ident;;
    let ini = init 5;;
    print_matrix ini;;
    print_matrix (transpose ini);;
    let i = init 5;;
    print_matrix i;;
    Array.iter (Printf.printf "%i ") (get_column 3 i);;
    *)



end
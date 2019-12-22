
module type Matrix = 
sig
    type 'a matrix 

    val create : int -> int -> int matrix
    val equivalence : int matrix -> int matrix -> bool
    val copy : int matrix -> int matrix
    val addition : int matrix -> int matrix -> int matrix
    val scalar_mult : int -> int matrix -> int matrix
    val mat_mult : int matrix -> int matrix -> int matrix
end
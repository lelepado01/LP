
module type StackI = 
sig
    type tp
    type stack

    exception Stack_is_empty

    val empty : unit -> stack
    val int_to_type : int -> tp
    val type_to_int : tp -> int
    val push : tp -> stack -> unit
    val pop : stack -> tp
    val top: stack -> tp
end
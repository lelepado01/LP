open IntegerStack

let s0 = IntegerStack.empty ();;
let s1 = IntegerStack.push (IntegerStack.int_to_type 3) s0;;
let x = IntegerStack.top s1;;
Printf.printf "%i\n" (IntegerStack.type_to_int x);;
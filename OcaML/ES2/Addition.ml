open OperationInterface

module Addition : OperationInterface = 
struct
    type op_type = int

    let operation = fun x y -> 
        x + y

end
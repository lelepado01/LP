
module type OperationInterface = 
sig
    type op_type

    val operation : op_type -> op_type -> op_type
end
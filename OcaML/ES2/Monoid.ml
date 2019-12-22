open OperationInterface
open Addition

module Monoid(O: OperationInterface) =
struct

    type op_type = O.op_type

    type monoid = {
        set: op_type list;
        op: op_type -> op_type;
        identity: op_type
        }

    let operate = fun x y -> 
        O.operation x y

end

module MAdd = Monoid(Addition);;
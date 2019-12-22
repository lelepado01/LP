open ConcreteMatrix

let test = ConcreteMatrix.create 3 3;;
let test2 = ConcreteMatrix.create 3 3;;
Printf.printf "%b" (ConcreteMatrix.equivalence test test2);;

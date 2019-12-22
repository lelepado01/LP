
class ListComp {

    def pow(n : Int, x : Int) : Int = {
        def aux_pow(n:Int, x:Int, i:Int, acc : Int) : Int= {
            if (i == x){
                return acc
            }

            aux_pow(n, x, i + 1, acc * n)
        }

        aux_pow(n, x, 0, 1)
    }    

    def squaredNumbers(ls : List[Any]) : List[Int] = {
        ls match {
            case (num : Int)::tl => pow(num, 2)::(squaredNumbers(tl))
            case (x : Any)::tl => squaredNumbers(tl)
            case Nil => Nil
        }
    }

    def cSquaredNumbers(ls : List[Any]) = for (num <- ls) num match {case (num : Int) => pow(num, 2) case (num : Any) => num case Nil => Nil}

}
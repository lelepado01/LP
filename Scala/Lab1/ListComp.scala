
object Main {
    def main(args : Array[String]) : Unit = {
        val ls1 = List(2,4,5,"ciao", 56)
        val ls2 = List(2,"ciao", 56)

        val l = new ListComp()
        print(l.symmetric_differenc(ls1, ls2))
    } 
}

class ListComp {

    def squaredNumbers(ls : List[Any]) : List[Int] = {
        var new_ls : List[Int] = List()
        for {l <- ls} l match {
            case l : Int => new_ls = (l*l) :: new_ls
            case x => Nil
        }

        new_ls.reverse
    }

    def intersect(ls1 : List[Any], ls2 : List[Any]) : List[Any] = {
        var ls : List[Any] = List() 
        for {l1 <- ls1} {
            for {l2 <- ls2} {
                if(l1 == l2){
                    ls = l1 :: ls
                }
            }
        }

        ls.reverse
    } 

    def symmetric_differenc(ls1 : List[Any], ls2 : List[Any]) : List[Any] = {
        var union = (ls1 ++ ls2).distinct
        val i = intersect(ls1, ls2)

        def subtract(ls1 : List[Any], ls2 : List[Any]) : List[Any] = {
            ls1 match {
                case l::tl => 
                    if(ls2.contains(l)){
                        subtract(tl, ls2)
                    }else{
                        l::subtract(tl, ls2)
                    }
                case Nil => Nil
            }
        }

        subtract(union, i)
    }

}
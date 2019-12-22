
class Factor {

    def isPrime(n : Int) : Boolean = {
        def isPrime(i : Int, n : Int) : Boolean = {
            if(i > n/2)
                return true
            if(n % i == 0){
                return false
            }else{
                isPrime(i+1, n)
            }
        }

        isPrime(2, n)
    }

    def primeList(n : Int) : List[Int] = {
        def primeList(index : Int, ls : List[Int], n : Int) : List[Int] = {
            if(index > n/2){
                return ls
            }else{
                if(n%index==0 && isPrime(index)){
                    primeList(index + 1, index::ls, n)
                }else{
                    primeList(index +1, ls, n)
                }
            }
        }

        primeList( 1, List(), n)
    }

    def isProper(n : Int) : Boolean = {
        val primes = primeList(n)
        
        def sum(acc : Int, primes: List[Int]) : Int = {
            primes match {
                case h::tl => sum(acc + h, tl)
                case Nil => acc 
            }
        }
        return n == sum(0, primes)
    }
}
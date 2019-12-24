
class AFMM {

    def isPrime(n : Int) : Boolean = {
        def auxPrime(n : Int, i : Int) : Boolean = {
            if (i > n/2){
                return true
            }
            if(n % i == 0){
                return false
            }
            auxPrime(n, i+1)
        }

        auxPrime(n, 2)
    }

    def goldbach(n : Int) : (Int, Int) = {
        def aux_gold(n : Int, i : Int) : (Int, Int) = {
            if(isPrime(i)){
                if (isPrime(n - i)){
                    return (i, n-i)
                }
            }

            if(i <= n / 2){
                aux_gold(n, i+1)
            }else{
                return (-1, -1)
            }
        }

        aux_gold(n, 2)
    }

    def goldbach_list(n : Int, m : Int) : List[(Int, Int)] = {
        def aux_gold_ls(n : Int, m : Int, i : Int) : List[(Int, Int)] = {
            if(i >= m){
                return Nil
            }
            if(i%2==0){
                goldbach(i)::aux_gold_ls(n, m, i+1)
            }else{
                aux_gold_ls(n, m, i+1)
            }
            
        }

        aux_gold_ls(n, m, n)
    }
}
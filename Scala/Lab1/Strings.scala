
class Strings {

    def is_palindrome(str : String) : Boolean = {
        if(str.length() == 1){
            return true
        }else if(str.length() == 2){
            return str.substring(0,1) == str.substring(1,2)
        }
           
        if(str.substring(0,1) == str.substring(str.length()-1, str.length())){
            is_palindrome(str.trim().substring(1, str.length()-1))
        }
            
        return false
    }

    def is_anagram(str : String, words : List[String]) : Boolean = {
        def strToList(str : String) : Array[Int] = {
            def strToList(str : String, i : Int, ls : Array[Int]) : Array[Int] = {
                def toASCII(c : Char) : Int = {
                    return 0
                }
                if(i == str.length()){
                    return ls
                }

                ls[toASCII(str.charAt(i))] += 1
                strToList(str, i+1, ls)
            }
            val letters = new Array[Int](26)
            return strToList(str, 0, letters)
        }
        def equals(str1 : String, str2 : String) : Boolean = {
            return strToList(str1) == strToList(str2)
        }
        words.exists(equals(_, str))
    }
}
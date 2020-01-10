import scala.util.parsing.combinator._

object Main {
    def main(s : Array[String]) : Unit = {
        val input = """ 1234 +
                       234 -
                       468 +
                         2 +
                         2 +
                         2 =
                      ------
                      1006"""

        val p = new Arithmetic_Parser()
        p.parseAll(p.eval, input) match {
            case p.Success(res, _) => println(res)
            case x => println(x.toString())
        }
    }
}

class Arithmetic_Parser() extends JavaTokenParsers {
    var intermediate_result : Int = 0
    var op : String = ""

    def eval() : Parser[Boolean] = schema ^^ {
        case op => op
    }

    def schema : Parser[Boolean] = rep(operation) ~ equal ~ ending ^^ {
        case o ~ e ~ end => end
    }
    def operation : Parser[Any] = addition | subtraction

    def addition : Parser[Any] = number <~ "+\n" ^^ {
        case n => 
            executeOperation(n)
            op = "+"
    }
    
    def subtraction : Parser[Any] = number <~ "-\n" ^^ {
        case n => 
            executeOperation(n)
            op = "-"
    }
    
    def equal : Parser[Any] = number <~ "=\n" ^^ {
        case n => executeOperation(n)
    }

    def ending : Parser[Boolean] = rep("-") ~> number ^^ {
        case n => n.toInt == intermediate_result
    }
    
    def number = wholeNumber

    def executeOperation(n : String) = {
        if (op == ""){
            intermediate_result = n.toInt
        } else if(op == "+"){
            intermediate_result += n.toInt
        }else{
            intermediate_result -= n.toInt
        }
    }
}
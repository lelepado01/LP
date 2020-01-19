import scala.util.parsing.combinator._
import java.lang.Number

object Main {
    def main(s : Array[String]) : Unit = {
        val input = "3 -2"
        val p = new Equation_Parser()
        p.parseAll(p.solve, input) match {
            case p.Success(res, _) => println(res)
            case x => println(x.toString())
        }
    }
}

class Equation_Parser() extends JavaTokenParsers {

    def solve : Parser[Any] = equation ^^ {
        case e => e
    }

    def equation : Parser[Any] = unaryOperation | binaryOperation | num

    def num = decimalNumber ^^ {
        case n => n.toDouble
    }

    def binaryOperation = num ~ binaryOperator ~ equation ^^ {
        case e1 ~ "+" ~ e2 => 
            parseAll(solve, e2.toString) match {
                case Success(res, _) => res match {
                    case i1 : Number => 
                        val r1 = i1.doubleValue()
                        r1 + e1
                }
                case x => print("Error")
            }
        case e1 ~ "-" ~ e2 => 
                parseAll(solve, e2.toString) match {
                case Success(res, _) => res match {
                    case i1 : Number => 
                        val r1 = i1.doubleValue()
                        e1 - r1
                }
                case x => 1.0
            }
    }

    def unaryOperation : Parser[Double] = unaryOperator ~ equation ^^ {
        case "sqrt" ~ e => 
            parseAll(solve, e.toString) match {
                case Success(res, _) => res match { case i: Number => 
                    val r = i.doubleValue() 
                    Math.sqrt(r)
                    }
                case x => 1.0
            }
        case x =>
            1.0
    }

    def binaryOperator = "+" | "-" | "*" | "/"

    def unaryOperator = "sin" | "cos" | "sqrt"
}
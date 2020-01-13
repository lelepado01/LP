//The input is just a series of titles, one per line. Any leading or trailing spaces should be removed. 
//Internal spaces should be retained (trimmed to one).
//A word is a maximal sequence of non-blank characters.
//The output line is at most 79 characters wide.
//The number is 5 characters wide, right-justified.
//There is a space after the number.
//The key word starts at position 40 (numbering from 1).
//If the part of the title left of the keyword is longer than 33, trim it (on the left) to 33.
//If the part of the keyword and the part to the right is longer than 40, trim it to 40.
//Each title appears in the output once for each word that isn't minor. 
//Any word of length two or less is minor, and and the words are minor words.
//If a title has a repeated word, it should be listed for each repetition.
//Sorting should be case-insensitive.

import scala.io.Source
import scala.collection.immutable.ListMap

object Main {
    def main(args : Array[String]) : Unit = {
        val file = Source.fromFile("src.txt")
        
        var lines : List[String] = List()

        file.getLines().foreach{
            l => 
                if(l != "\n" && l != "" && l != " ")
                    lines ::= l
        }

        val kwic = new KWIC(lines.length)
        kwic.createMap(lines)
    }
}

class KWIC(len : Int) {
    var lines : Array[String] = new Array[String](len)
    var words : Map[String, Int] = Map()

    def createMap(ls : List[String]) : Unit = {
        def fillArr(index : Int, l : List[String]) : Unit = {
            l match {
                case h::tl => 
                    if(index < lines.length){
                        lines(index) = h
                        fillArr(index + 1, tl)
                    }
                case Nil => Nil
            }
        }

        fillArr(0, ls)
        var l = 1
        for{line <- lines} {
            val wordsInLine = line.split(" ")
            
            for {word <- wordsInLine} {
                if(!words.contains(word)){
                    words += (word -> l)
                }
            }
            l+=1
        }

        this.words = sortMap()
        for {(word, l) <- words} printLineWithOffset(word, l)
    }

    def sortMap() : Map[String, Int] = {
        return ListMap(words.toSeq.sortBy(_._1):_*)
    }

    def printLineWithOffset(w : String, l : Int) : Unit = {
        def getWordOffset(line : String, off : Int) : Int = {
            if(off < line.length){
                if(line.charAt(off) == w.charAt(0)){
                    if(line.substring(off, off+w.length) == w){
                        return off
                    }else{
                        getWordOffset(line, off+1)
                    }
                }else{
                    getWordOffset(line, off+1)
                }
            }else{
                return 0
            }
        }
        val off = 79 - getWordOffset(lines(l-1), 0)
        var o = 0
        while (o < off){
            print(" ")
            o+=1
        }
        println(lines(l-1))
    }
}
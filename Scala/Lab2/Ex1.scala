
// "3 + 2 - 1 * 4"
class CustomNumber(d : Double) {
    var value : Double = d 

    def + (n : CustomNumber) = {
        this.value = this.value + n.value
        this
    }
}

object equation {
    def apply(eq : Double) = {
        print(eq.value)
    }

    implicit def double2Number(i : Double) : CustomNumber = {
        new CustomNumber(i)
    }

    implicit def int2Number(i : Int) : CustomNumber = {
        new CustomNumber(i.toDouble)
    }
}

object Main {
    val calculator = equation {
        3 + 2 * 5
    }
}
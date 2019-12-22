import akka.actor.typed.ActorRef
import akka.actor.typed.ActorSystem
import akka.actor.typed.Behavior
import akka.actor.typed.scaladsl.Behaviors

object Actor {
    case class Greet(whom : String, reply: ActorRef[Greeted])
    case class Greeted(whom : String, reply : ActorRef[Greet])

    def apply() : Behavior[Greet] = {
        Behaviors.receive {
            (context, message) => 
                context.log.info("Hello {}", message.whom)
                message.reply ! Greeted(message.whom, context.self)
                Behaviors.same
        }
    }
}

object GreeterBot {

    def apply(max : Int) : Behavior[Actor.Greeted] = {
        bot(0,max)
    } 

    private def bot(counter : Int, max : Int) : Behavior[Actor.Greeted]= {
        Behaviors.receive {
            (context, message) => 
                val n = counter + 1
                context.log.info("Greets: {} for {}", n, message.whom)
                if(n==max){
                    Behaviors.stopped
                }else{
                    message.from ! Actor.Greet(message.whom, context.self)
                    bot(n, max)
                }
        }
    }
}

object Main {

    case class Start(name : String)

    def apply() : Behavior[Start] = {
        Behaviors.setup {
            context => 
                val greeter = context.spawn(Greeter(), "greeter")

                Behaviors.receiveMessage {
                    message => 
                        val replyTo = context.spawn(GreeterBot(max = 3), message.name)
                        greeter ! Greeter.Greet(message.name, replyTo)
                        Behaviors.same
                }
        }
    }
}


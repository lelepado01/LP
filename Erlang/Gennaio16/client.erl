-module(client).
-export([convert/5]).

convert(from, F, to, T, V) -> 
    sys ! {from, F, to, T, V, self()}, 
    receive
        {ret, R} -> io:format("Result: ~p\n", [R])
        after 1000 -> io:format("Timeout\n")
    end.
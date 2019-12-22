-module(client).
-export([is_prime/1]).

is_prime(Num) ->
    sif@lelepado ! {new, Num, self()}, 
    io:format("is ~p prime? ", [Num]),
    receive
        {result, true} ->
            true;
        {result, false} ->
            false
    end.
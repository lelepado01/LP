-module(sieve).
-export([sieve_wait/2]).

sieve_wait(Next, Prime) ->
    receive
        {pass, N} when N > Prime -> Next ! {pass, N}, sieve_wait(Next, Prime);
        {pass, N} -> controller ! {res, N == Prime}, sieve_wait(Next, Prime);
        {stop} -> io:format("Stopping\n"), Next ! {stop}
    end.
-module(controller).
-export([start/1]).
-import(sieve, [sieve_wait/2]).

start(N) ->
    register(controller, self()), 
    controller_wait(N, spawn(fun() -> spawn_ring(N) end)).

controller_wait(Max, Start) ->
    receive
        {new, N, Src} when N > Max -> Src ! {result, illegal};
        {new, N, Src} -> 
            Start ! {pass, N},
            io:format("Asked for: ~p\n", [N]),
            receive
                {res, R} -> Src ! {result, R}
                after 1000 ->  io:format("Timeout\n")
            end, 
            controller_wait(Max, Start);
        {quit} -> io:format("Asked for quit"), Start ! {stop}
    end.

spawn_ring(N) -> 
    Start = self(),
    sieve_wait(spawn(fun() -> spawn_ring(N, get_next_prime(2), Start) end), 1). 

spawn_ring(N, I, Start) when N < I -> sieve_wait(Start, get_next_prime(I));
spawn_ring(N, I, Start) -> 
    Next_prime = get_next_prime(I),
    sieve_wait(spawn(fun() -> spawn_ring(N, Next_prime+1, Start) end), Next_prime).

get_next_prime(P) -> 
    case is_prime(P) of 
        true -> P;
        false -> get_next_prime(P+1)
    end.

is_prime(P) -> is_prime(P, 2).
is_prime(P, I) when P < 2 * I -> true;
is_prime(P, I) when P rem I == 0 -> false;
is_prime(P, I) -> is_prime(P, I+1).
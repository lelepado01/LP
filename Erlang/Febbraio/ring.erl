-module(ring).
-export([start/2, send_message/1, send_message/2, stop/0]).

start(N, L) -> 
    register(term, self()),
    register(start, spawn(fun() -> create_ring(N, L) end)).

create_ring(N, [H|Tl]) -> 
    Start = self(), 
    ring_wait(H, 0, spawn(fun() -> create_ring(N, 1, Tl, Start) end)).

create_ring(N, I, [H|_], Start) when N-1 == I -> ring_wait(H, I, Start);
create_ring(N, I, [H|Tl], Start) -> ring_wait(H, I, spawn(fun() -> create_ring(N, I+1, Tl, Start) end)).

ring_wait(F, Num, Next) ->
    receive 
        {mess, V} when Num == 0 -> 
            term ! {res, V}, ring_wait(F, Num, Next);
        {mess, V} -> 
            Next ! {mess, F(V)}, ring_wait(F, Num, Next);
        {new, V} -> 
            Next ! {mess, F(V)}, ring_wait(F, Num, Next);
        {mess, V, 1} when Num == 0 -> 
            term ! {res, V}, ring_wait(F, Num, Next);
        {mess, V, N} when Num == 0 -> 
            Next ! {mess, F(V), N-1}, ring_wait(F, Num, Next);
        {mess, V, N} ->
            Next ! {mess, F(V), N}, ring_wait(F, Num, Next);
        {new, V, N} -> 
            Next ! {mess, F(V), N}, ring_wait(F, Num, Next);
        {stop} -> 
            io:format("Stopping: ~p\n", [Num]), Next ! {stop}
    end.

send_message(I) -> 
    start ! {new, I}, 
    receive
        {res, V} -> io:format("Result: ~p\n", [V])
        after 1000 -> io:format("Timeout\n")
    end.

send_message(I, N) -> 
    start ! {new, I, N}, 
    receive
        {res, V} -> io:format("Result: ~p\n", [V])
        after 1000 -> io:format("Timeout\n")
    end.

stop() -> start ! {stop}.
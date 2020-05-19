-module(joseph).
-export([joseph/2]).
-import(hebrew, [hebrew_wait/2]).

joseph(N, K) ->
    register(controller, self()), 
    spawn(fun() -> start_ring(N, 1) end) ! {kill, K, 0}, 
    receive
       {survivor, S} -> io:format("In a circle of ~p hebrews, joseph is ~p\n", [N, S])
    end, 
    unregister(controller).

start_ring(N, 1) -> Start = self(), hebrew_wait(spawn(fun() -> start_ring(N, 2, Start) end), 1).
start_ring(N, N, Start) -> hebrew_wait(Start, N);
start_ring(N, I, Start) -> hebrew_wait(spawn(fun() -> start_ring(N, I+1, Start) end), I).

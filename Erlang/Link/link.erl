-module(link).
-export([start/1, new/1]).
-import(hello, [hello/0]).

start(N) -> 
    process_flag(trap_exit, true), 
    spawn_link(fun() -> start(0, N) end), 
    receive
        {'EXIT', _ , R} -> R
    end.

start(N, N) -> exit(die);
start(I, N) -> spawn_link(fun() -> start(I+1, N) end), wait().

wait() -> 
    io:format("Process ~p waiting\n", [self()]),
    receive M -> M end.

new(Node) -> spawn(Node, hello, hello, []).

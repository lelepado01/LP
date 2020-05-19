-module(ex3).
-export([start/2, stop/0]).

wait(Next, I) ->
    receive
        {send, Message} -> 
            io:format("Process: ~p, ~p\n", [I, Message]), 
            Next ! {send, Message},
            wait(Next, I);
        {quit} ->
            io:format("Quitting\n"),
            Next ! {quit}
    end.

spawn_ring(N, I, Main) ->
    case N < I of
        true -> 
            Next = spawn(fun() -> spawn_ring(N, I+1, Main) end),
            wait(Next, I);
        false ->
            Next = start,
            Main ! {ok},
            wait(Next, I)
    end.

start(N, Message) ->
    Pid = self(),
    Start = spawn(fun() -> spawn_ring(N, 0, Pid) end),
    register(start, Start),
    receive
        {ok} -> start ! {print, Message}
    end,
    start ! {send, Message},
    receive after 5 -> stop() end.

stop() ->
    start ! {quit}.
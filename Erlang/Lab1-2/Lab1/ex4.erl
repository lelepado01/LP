
-module(ex4).
-export([start/0, print/1, stop/0]).

wait() ->
    receive 
        {print, Str} -> io:format(Str), wait();
        {quit} -> io:format("Quitting\n")
    end.

start() -> 
    Pid = spawn(fun() -> wait() end),
    case register(server, Pid) of
        true ->
            io:format("Server Started\n");
        false ->
            io:format("Error\n")
    end.

stop() -> 
    server ! {quit}.

print(Str) -> 
    server ! {print, Str}.
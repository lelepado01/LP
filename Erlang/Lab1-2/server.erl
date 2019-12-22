-module(server).
-export([start/0, print/1, stop/0, wait/0]).

wait() ->
    receive
        quit -> io:format("Quitting Server\n");
        Str -> 
            io:format("~p\n", [Str]), 
            wait()
    end.

start() ->
    Pid = spawn(fun() -> wait() end),
    case register(server, Pid) of
        true -> io:format("Server Started!\n");
        false -> io:format("Unable to Start Server\n")
    end.

print(Mess) ->
    Pid = whereis(server),
    Pid ! Mess,
    io:format("").

stop() ->
    Pid = whereis(server),
    Pid ! quit.
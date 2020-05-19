-module(ex5).
-export([start/0, serv/0, stop/0, print/0]).

wait(Count) ->
    receive
        {serv} ->
            wait(Count+1);
        {quit} ->
            io:format("~p\n", [Count]);
        {print} ->
            io:format("~p\n", [Count]),
            wait(Count+1)
    end.

start() ->
    Pid = spawn(fun() -> wait(0) end),
    case register(server, Pid) of
        true ->
            io:format("Server Started\n");
        false ->
            io:format("Error\n")
    end.

stop() ->
    server ! {quit}.

serv() ->
    server ! {serv}.

print() ->
    server ! {print}.
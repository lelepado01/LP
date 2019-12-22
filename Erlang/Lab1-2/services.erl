-module(services).
-export([request/0, start/0, stop/0]).

wait_with_c(Counter) ->
    receive
        stop -> io:format("Service Stopped\n");
        _ -> 
            io:format("Service called: ~p Times\n", [Counter + 1]), 
            wait_with_c(Counter + 1)
    end.

start() ->
    Pid = spawn(fun() -> wait_with_c(0) end),
    case register(server1, Pid) of
        true -> io:format("Server Started!\n");
        false -> io:format("Error!\n")
    end.

request() ->
    Pid = whereis(server1),
    Pid ! 0,
    io:format("").
    
stop() -> 
    Pid = whereis(server1), 
    Pid ! stop,
    io:format("").
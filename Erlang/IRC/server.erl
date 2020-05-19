-module(server).
-export([server_start/0]).
-import(middleman, [start/0]).

server_start() -> register(server, self()), server_wait().

server_wait() ->
    receive
        {connect, N, P} -> io:format("~p enters the chat\n", [N]), put(N, spawn(N, middleman, start, [P])), server_wait();
        {disconnect, N} -> io:format("~p leaves the chat\n", [N]), erase(N), server_wait();
        {send, M, P} -> io:format("~p sent ~p\n", [P, M]), lists:map(fun({_, Pr}) -> Pr ! {new, {P, M}} end, get()), server_wait()
    end.
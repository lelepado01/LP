-module(client).
-export([connect/0, disconnect/0, send/1, refresh/0]).

connect() -> {server, 'server@MBP-di-Gabriele'} ! {connect, node(), self()}.

disconnect() -> mm ! {disconnect}.

send(M) -> mm ! {send, M}.

refresh() -> 
    mm ! {refresh}, 
    receive
        {refresh, L} -> lists:map(fun({P, M}) -> io:format("~p: ~p\n", [P, M]) end, lists:reverse(L))
        after 1000 -> timeout
    end.
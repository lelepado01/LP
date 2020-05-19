-module(ex2).
-export([start/0, store/2, lookup/1, stop/0, list/0]).

start() ->
    Pid = spawn(fun() -> wait([]) end),
    register(server, Pid).

server_lookup(_Tag, []) ->
    "Value not Found";
server_lookup(Tag, [{T, V}|Tl]) ->
    case Tag == T of
        true -> V;
        false -> server_lookup(Tag, Tl)
    end.

wait(Ls) ->
    receive
        {store, Tag, Value} ->
            wait(lists:append([{Tag, Value}],Ls));
        {lookup, Tag} ->
            io:format("~p\n", [server_lookup(Tag, Ls)]),
            wait(Ls);
        {list} ->
            lists:map(fun({E1, E2})-> io:format("~p, ~p\n", [E1, E2]) end, Ls),
            wait(Ls);
        {quit} -> 
            io:format("Quitting\n")
    end.

store(Tag, Value) ->
    server ! {store, Tag, Value}.

lookup(Tag) ->
    server ! {lookup, Tag}.

list() ->
    server ! {list}.

stop() ->
    server ! {quit}.
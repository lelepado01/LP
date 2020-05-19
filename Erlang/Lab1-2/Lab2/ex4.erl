-module(ex4).
-export([start/1]).

get_index(_, []) -> "";
get_index(I, [{Id, V}|Tl]) -> 
    case I == Id of 
        true -> V;
        false -> get_index(I, Tl)
    end.


list_length([]) -> 0;
list_length([_|Tl]) -> 1 + list_length(Tl).

list_concat(Ls) -> list_concat(Ls, 0, list_length(Ls), "").
list_concat(Ls, I, Max, Out) ->
    case I < Max of 
        true ->
            list_concat(Ls, I+1, Max, string:join([get_index(I, Ls), Out], ""));
        false -> Out
    end.

list_print([]) -> io:format("\n");
list_print([H|Tl]) -> 
    io:format("~p, ", [H]),
    list_print(Tl).

wait_response(Ls, I, Max, Pid) ->
    case I < Max of 
        true ->
            receive
                {answer, Id, S} -> 
                    wait_response(lists:append([{Id, S}], Ls), I+1, Max, Pid)
            end;
        false ->
            list_print(Ls),
            Pid ! {answer, list_concat(Ls)}
    end.    

sleep(N) -> receive after N -> {} end.

slave_exec(I, Str) ->
    sleep(5),
    server ! {answer, I, string:reverse(Str)}.

split_str(N, Str, L) -> split_str(N, 0, Str, L).
split_str(N, Index, Str, Len) ->
    case Index < N of 
        true ->
            case Index == N - 1 of
                true ->
                    spawn(fun() -> slave_exec(Index, Str) end),
                    split_str(N, Index+1, Str, Len);
                false ->
                    spawn(fun() -> slave_exec(Index, string:sub_string(Str, 1, Len)) end),
                    split_str(N, Index+1, string:sub_string(Str, Len+1), Len)
            end;
        false ->
            spawn(fun() -> slave_exec(Index, Str) end)
    end.

server_start(N, S, Pid) ->
    split_str(N, S, floor(string:length(S)/(N-1))),
    wait_response([], 0, N, Pid).

start(Str) ->
    Pid = self(),
    register(server, spawn(fun() -> server_start(10, Str, Pid) end)), 
    receive
        {answer, S} -> io:format("~p\n", [S])
    end,
    io:format("Start Len = ~p\n", [string:length(Str)]),
    io:format("End Len = ~p\n", [string:length(S)]).
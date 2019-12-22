-module(reverse).
-export([start/0, lrs/1, reset/0, string_split_reverse/2]).


list_add({N, Str}, []) ->
    [{N, Str}];
list_add({N1, Str1}, [{N2, Str2}|Ls]) ->
    case N1 < N2 of
        true ->
            lists:append([{N1, Str1}], [{N2, Str2}| Ls]);
        false ->
            lists:append([{N2, Str2}], list_add({N1, Str1}, Ls))    
    end.



list_length(Ls) ->
    lists:foldl(fun(_El, Acc) -> Acc + 1 end, 0, Ls).
list_print([]) ->
    io:format("\n");
list_print([{_N, Str}|Ls]) ->
    io:format("~p ", [Str]),
    list_print(Ls).

ms_wait(Pid_list, ResultList, Frag_Num) ->
    receive
        {reset} -> 
            ms_wait(Pid_list, [], Frag_Num);
        {answer, {Pos, Str}} -> 
            New_List = list_add({Pos, Str}, ResultList),
            case Frag_Num == list_length(New_List) of
                true ->
                    dst ! {final, New_List},
                    ms_wait(Pid_list, New_List, Frag_Num);
                false ->
                    ms_wait(Pid_list, New_List, Frag_Num)
            end;
        {rev, {N, Str}} -> 
            io:format("~p ", [lists:nth(N, Pid_list)]),
            lists:nth(N, Pid_list) ! {rev, {N, Str}}, 
            ms_wait(Pid_list, ResultList, Frag_Num)
    end.

slave_wait() ->
    receive
        {rev, {N, Str}} -> 
            master ! {answer, {N, string:reverse(Str)}},
            slave_wait()
    end.

createProcesses(0, Ls) ->
    Ls;
createProcesses(N, Ls) ->
    createProcesses(N-1, [spawn(fun() -> slave_wait() end)|Ls]).

start() ->
    Pid_list = createProcesses(10, []),
    register(dst, self()),
    register(master, spawn(fun() -> ms_wait(Pid_list, [], 10) end)).
    

string_split_reverse(Str, N) ->
    case string:length(Str) < N of
        true ->
            Len = 1,
            string_split_reverse(Str, N, Len);
        false -> 
            Len = floor(string:length(Str)/(N)),
            string_split_reverse(Str, N, Len)
    end.
    

string_split_reverse(Str, N, Len) ->
    case string:length(Str) < Len of
        true ->
            %io:format("~p \n", [string:left(Str, Len)]),
            master ! {rev, {N, Str}};
        false ->
            master ! {rev, {N, string:left(Str, Len)}},
            %io:format("~p \n", [string:left(Str, Len)]),
            string_split_reverse(string:slice(Str, Len), N-1, Len)
    end.

lrs(Str) ->
    string_split_reverse(Str, 11), 
    receive
        {final, Ls} -> 
            list_print(Ls)
    end.

reset() ->
    master ! {reset}.
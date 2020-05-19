-module(reverse).
-export([start/1, start_slave/3]).

lists_len(L) -> lists:foldl(fun(_, Acc) -> Acc+1 end, 0, L).

lists_append(I, S, []) -> [{I, S}];
lists_append(I, S, [{I1, S1}|Tl]) when I > I1 -> lists:concat([[{I1, S1}], lists_append(I, S, Tl)]);
lists_append(I, S, [{I1, S1}|Tl]) -> lists:concat([[{I, S}], [{I1, S1}], Tl]).

lists_concat(Ls) -> lists_concat(Ls, "").
lists_concat([], Acc) -> Acc;
lists_concat([{_, H}|Tl], Acc) -> lists_concat(Tl, string:concat(H, Acc)).

wait(Ls) ->
    receive
        {answer, I, S} -> 
            io:format("Received: ~p\n", [I]),
            case lists_len(Ls) == 9 of   
                false -> wait(lists_append(I, S, Ls));
                true -> lists_concat(lists_append(I, S, Ls))
            end
        after 5000 -> io:format("Timed Out\n")
    end.

handle(S, Src) -> 
    L = trunc(string:len(S)/10) + 1,
    handle(S, Src, 0, 9, L).


handle(S, Src, I, Max, _) when I == Max -> 
    case S == [] of 
        true -> spawn('sif@MBP-di-Gabriele', reverse, start_slave, ["", I, Src]);
        false -> spawn('sif@MBP-di-Gabriele', reverse, start_slave, [S, I, Src])
    end;
handle([], Src, I, Max, Len) -> 
    spawn('sif@MBP-di-Gabriele', reverse, start_slave, ["", I, Src]),
    handle("", Src, I+1, Max, Len);
handle(S, Src, I, Max, Len) -> 
    case string:len(S) < Len of 
        true ->
            spawn('sif@MBP-di-Gabriele', reverse, start_slave, [S, I, Src]),
            handle("", Src, I+1, Max, Len);
        false ->
            spawn('sif@MBP-di-Gabriele', reverse, start_slave, [string:slice(S, 0, Len), I, Src]),
            handle(string:sub_string(S, Len+1), Src, I+1, Max, Len)
        end.

start_slave(S, I, Src) -> 
    io:format("Done: ~p\n", [I]),
    Src ! {answer, I, string:reverse(S)}.


start(S) -> 
    register(term, self()),
    %Src = {term, node()},
    Src = self(),
    io:format("Self: ~p\n", [Src]),
    handle(S, Src), 
    Res = wait([]), 
    unregister(term),
    Res.
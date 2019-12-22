%program che crea N processi in anello
%manda M messaggi in cerchio e ferma quando arriva quit

-module(ex3).
-export([start/3, stop/0]).

setuplink() ->
    receive
        Pid -> link(Pid), io:format("Link Created with ~p", [Pid])
    end.

create_ring(M, Created, Ls) ->
    case M > Created of
        true -> 
            Pid = spawn(ring_proc, setuplink(), []),
            create_ring(M, Created+1, [Pid | Ls]);
        false -> Ls
    end.

print_list([H|Tl]) ->
    case H =/= [] of
        false -> io:format("\n");
        true ->
            io:format("~p ", [H]),
            print_list(Tl)
    end.

set_links(Arr, Index) ->
    case Index == 0 of
        true -> array:get(Arr, Index) ! array:get(Arr, array:length(Arr)-1);
        false -> 
            case Index == array:length(Arr)-1 of
                true -> array:get(Arr, Index) ! array:get(Index-1), set_links(Arr, Index+1);
                false -> array:get(Arr, Index) ! array:get(Index-1)
            end
    end.

start(M, N, Mess) ->
    Ls = create_ring(M, 0, []), 
    set_links(array:from_list(Ls), 0).

stop() -> 0.


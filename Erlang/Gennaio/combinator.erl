-module(combinator).
-export([start/2, create_gens/2]).
-import(generator, [create/3]).

ms_wait(From, N, Index, Out_list) ->
    receive
        {list, {Col, Ls}} ->
            case N == Index of
                true -> From ! {answer, lists:append([{Col, Ls}], Out_list)};
                false -> ms_wait(From, N, Index+1, lists:append([{Col, Ls}], Out_list))
            end
    end.

create_gens(N, _M, Index, Ls) when N == Index - 1 -> Ls;
create_gens(N, M, Index, Ls) -> create_gens(N, M, Index+1, lists:append([generator:create(N, M, Index)], Ls)).
create_gens(N, M) -> create_gens(N, M, 1, []).

list_length(Ls) -> lists:foldl(fun(_, Acc) -> Acc + 1 end, 0, Ls).

print_line(N, L, [{N, Ls}|_Tl]) -> io:format("~p ", [lists:nth(L, Ls)]);
print_line(N, L, [{_C, _} | Tl]) -> print_line(N, L, Tl).

list_print(N, 1, Len, Ls) ->
    print_line(1, Len, Ls),
    io:format("\n"),
    list_print(N, N, Len+1, Ls);
list_print(N, Index , Len, Ls) ->
    {_, Sample} = lists:nth(1,Ls),
    case list_length(Sample) == Len of
        true -> io:format("\n");
        false -> print_line(Index, Len, Ls), list_print(N, Index-1, Len, Ls)
    end.
list_print(N, Ls) -> list_print(N, N , 1, Ls).

start(N, M) ->
    Pid = self(),
    register(master, spawn(fun() -> ms_wait(Pid, N, 1, []) end)),
    create_gens(N, M),
    receive
        {answer, Ls} ->
            list_print(N, Ls)
    end.
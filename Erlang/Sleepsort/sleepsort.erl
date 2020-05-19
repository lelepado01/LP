-module(sleepsort).
-export([sort/1]).

sort(L) -> sort(L, self(), lists:foldl(fun(_, A) -> A+1 end, 0, L)).
sort([], _, L) -> wait(0, L);
sort([H|Tl], P, L) -> spawn(fun() -> sleep(H, P) end), sort(Tl, P, L).

sleep(T, P) -> receive after T -> P ! {sort, T} end.

wait(N, N) -> print_ls(0, N);
wait(I, N) -> 
    receive 
        {sort, V} -> put(I, V), wait(I+1, N)
    end.

print_ls(N, N) -> io:format("\n");
print_ls(I, N) -> io:format("~p, ", [get(I)]), print_ls(I+1, N).
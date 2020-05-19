-module(combinator).
-export([start/2]).
-import(generator, [column/4]).

start(N, M) -> 
    spawn_generator(N, 1, M, self()), 
    wait(N, 0).

spawn_generator(N, N, M, S) -> spawn(fun() -> column(N, M, N, S) end);
spawn_generator(N, I, M, S) -> spawn(fun() -> column(N, M, I, S) end), spawn_generator(N, I+1, M, S).

wait(N, N) -> print(list_len(get(1)), N);
wait(N, I) ->
    receive
        {col, C, L} -> put(C, L), wait(N, I+1)
        after 1000 -> io:format("Timeout\n")
    end.

print(C, R) -> print_col(C, 1, R, R).
print_col(C, Ic, R, 1) -> io:format("~p, ", [lists:nth(Ic, get(1))]), io:format("\n"), print_col(C, Ic+1, R, R);
print_col(C, C, _, Ir) -> io:format("~p, ", [lists:nth(C, get(Ir))]), io:format("\n");
print_col(C, Ic, R, Ir) -> io:format("~p, ", [lists:nth(Ic, get(Ir))]), print_col(C, Ic, R, Ir-1).

list_len(L) -> lists:foldl((fun(_, Acc) -> Acc+1 end), 0, L).
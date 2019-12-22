% to execute this test from command-line use: erl -sname sif -noshell -eval 'test:test()' -s init stop
%-module(test).
%-export([test/0]).
%
%test() ->
%  testf(sleepsort, start, []),
%  testf(client, queries, [[5,1,0,1000,100, 90, 102, 33, 25, 7, 8, 99, 23, 99, 34, 11, 250]]),
%  testf(client, queries, [[5000,4000,3000,2000,1000,900,800,700,600,500,400,300,200,100,90,80,70,60,50,40,30,20,10,9,8,7,6,5,4,3,2,1,0]]),
%  testf(client, queries, [quit]).
%
%testf(M,F,A) ->
%  receive  % this is to let an eventual registered name being freed by the system
%     after 250 -> none
%  end,
%  R = apply(M, F, A),
%  io:format("~p~n", [R]).

-module(sleepsort).
-export([sort/1]).

list_length(Ls) -> lists:foldl(fun(_, Acc) -> Acc + 1 end, 0, Ls).

act_wait(T) -> receive after T -> server ! {res, T} end, exit(normal).

create_acts([H|_], Max, Max) -> spawn(fun() -> act_wait(H) end);
create_acts([H|Tl], Index, Max) ->
    spawn(fun() -> act_wait(H) end),
    create_acts(Tl, Index+1, Max).

wait(Ls, Out) ->
    receive
        {res, N} -> 
            case list_length(Ls) == list_length(Out) + 1 of
                true -> lists:append([N], Out);
                false -> wait(Ls, lists:append([N], Out))
            end
    end.

sort(Ls) ->
    register(server, self()), 
    create_acts(Ls, 1, list_length(Ls)),
    Sorted = wait(Ls, []),  
    unregister(server), 
    lists:reverse(Sorted).
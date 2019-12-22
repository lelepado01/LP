-module(tempsys).
-export([startsys/0]).

createAct1(1, [H|_]) -> spawn(fun() -> loop1(H) end);
createAct1(N, [H|Tl]) -> lists:append(spawn(fun() -> loop1(H) end), createAct1(N-1, Tl)).

createAct2(1, [H|_], Act_list) -> spawn(fun() -> loop2(H, Act_list) end);
createAct2(N, [H|Tl], Act_list) -> lists:append(spawn(fun() -> loop2(H, Act_list) end), createAct2(N-1, Tl, Act_list)).

toC(X) -> X.
toF(X) -> X*9/5 + 32.
toK(X) -> X + 273.15.
toR(X) -> (X + 273.15) * 9/5. 
toDe(X) -> (100-X)*3/2.
toN(X) -> X*33/100.
toRe(X) -> X * 4/5.
toRo(X) -> X * 21/40 + 7.5.

fromC(X) -> X.
fromF(X) -> (X -32) * 5/9.
fromK(X) -> X -273.15.
fromR(X) -> X*5/9 - 273.15.
fromDe(X) -> 100 - X * 2/3.
fromN(X) -> X *100 /33.
fromRe(X) -> X * 5/4.
fromRo(X) -> (X -7.5) *40/21.

loop1({Label, Fun}) ->
    receive
        {toScale, Label, Val, From_act, From_client} ->
            From_act ! {result, Fun(Val), From_client},
            loop1({Label, Fun})
    end.

loop2({Label, Fun}, Act_list) ->
    receive
        {toC, From_scale, Val, To, From_client} ->
            lists:map(fun(El) -> El ! {toScale, To, Fun(Val), self(), From_client} end, Act_list), 
            loop2({Label, Fun}, Act_list);
        {result, Val, From} -> 
            From ! {result, Val},
            loop2({Label, Fun}, Act_list)
    end.

startsys() ->
    Ls1 = [
        {'C', fun toC/1},
        
    ]

    First_act = createAct1(8, Ls1),
    Second_act = createAct2(8, Ls2, First_act).
-module(list_com).
-export([squared_int/1, intersect/2, symmetric_difference/2]).

squared_int(Ls) ->
    [floor(math:pow(X, 2)) || X <- Ls, is_integer(X)].

is_member(X, Ls) ->
    lists:any(fun(Y) -> X == Y end, Ls).

intersect(Ls1, Ls2) -> 
    [X || X <- Ls1, is_member(X, Ls2)].

symmetric_difference(Ls1, Ls2) -> 
    lists:merge([X || X <- Ls1, not is_member(X, Ls2) ], [ Y || Y <- Ls2, not is_member(Y, Ls1) ]).

-module(ex1).
-export([squared_int/1, intersect/2, symmetric_difference/2]).

squared_int(Ls) -> [X*X || X <- Ls , is_integer(X)].

is_member(X, Ls) -> lists:any(fun(E) -> E == X end, Ls).

intersect(Ls1, Ls2) -> [X || X <- Ls1, is_member(X, Ls2)].

subtract(Ls1, Ls2) -> [X || X <- Ls1, not is_member(X, Ls2)].

symmetric_difference(Ls1, Ls2) -> 
    lists:append(subtract(Ls1, intersect(Ls1, Ls2)), subtract(Ls2, intersect(Ls1, Ls2))).

-module(ex1).
-export([is_proper/1]).



is_proper(N, Acc, Index) ->
    case (N / 2) + 1 > Index of
        true -> 
            case N rem Index == 0 of
                true ->
                    is_proper(N, Acc + Index, Index + 1);
                false ->
                    is_proper(N, Acc, Index + 1)
            end;
        false -> 
            N == Acc
    end.

is_proper(N) -> 
        is_proper(N, 0, 1).
        
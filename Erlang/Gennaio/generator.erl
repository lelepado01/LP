-module(generator).
-export([create/3]).


% il primo itera N^M volte da 1 a M
% il secondo ripete Index M volte e poi incrementa Index
% l'ennesimo ripete Index M Col volte e poi incrementa index

list_length(Ls) -> lists:foldl(fun(_, Acc) -> Acc + 1 end, 0, Ls).

create_same_num_list(Val, Len, Len) -> [Val];
create_same_num_list(Val, Len, Index) -> lists:append([Val], create_same_num_list(Val, Len, Index+1)).
create_same_num_list(Val, Len) -> create_same_num_list(Val, Len, 1).

create_list(Max, Col, M, Index, Ls) ->
    case list_length(Ls) + 1 > Max of
        true -> lists:reverse(Ls);
        false -> 
            case Index == M of
                true -> create_list(Max, Col, M, 1, lists:append(create_same_num_list(Index, floor(math:pow(M, Col-1))), Ls));
                false -> create_list(Max, Col, M, Index+1, lists:append(create_same_num_list(Index, floor(math:pow(M, Col-1))), Ls))
            end
    end.

create_list(N, M, Col) -> create_list(floor(math:pow(M,N)), Col, M, 1, []).

calc_list(N, M, Col) ->
    Ls = create_list(N, M, Col),
    master ! {list, {Col, Ls}}.

create(N, M, Col) ->
    spawn(fun() -> calc_list(N, M, Col) end).
-module(ex1).
-export([is_palindrome/1, is_an_anagram/2, factor/1, is_proper/1]).


is_palindrome(Str) ->
    case (string:length(Str) == 1) or (string:length(Str) == 0) of
        true -> true;
        false -> 
            case string:left(string:trim(Str), 1) == string:right(string:trim(Str), 1) of
                true -> is_palindrome(string:sub_string(Str, 2, (string:length(Str)-1)));
                false -> false
            end
    end.    

get_new_arr() -> array:set(26, 0, array:new()).

convert_to_array(Str, Arr) ->
    case string:length(Str) == 0 of
        true -> Arr;
        false ->
            array:set(hd(Str)-65, array:get(hd(Str)-65, Arr)+1, Arr),
            convert_to_array(string:sub_string(Str, 1), Arr)
    end.

array_cmp(Arr1, Arr2, C) ->
    case array:get(C, Arr1) == array:get(C, Arr2) of
        true -> array_cmp(Arr1, Arr2, C+1);
        false -> false
    end.

array_are_equal(Arr1, Arr2) ->
    case array:length(Arr1) =/= array:length(Arr2) of
        true -> false;
        false -> array_cmp(Arr1, Arr2, 0)
    end.

is_anagram(Str1, Str2) -> 
    array_are_equal(convert_to_array(string:to_upper(Str1), get_new_arr()), convert_to_array(string:to_upper(Str2), get_new_arr())).

is_anagram(Str, [H|Tl], C) -> 
    case is_anagram(Str, H) of
        true -> is_anagram(Str, Tl, C+1);
        false -> is_anagram(Str, Tl, C)
    end;
is_anagram( _, [], C) ->
    C.

is_an_anagram(Str, Str_list) -> 
    is_anagram(Str, Str_list, 0).

rec_is_prime(N, D) -> 
    case (N / 2)+1 > D of
        true -> 
            if
                N rem D == 0 ->
                    false;
                true ->
                    rec_is_prime(N, D+1)
            end;
        false -> true
    end.

is_prime(N) ->
    rec_is_prime(N, 2).

factor(N, Index) ->
    case N > Index of
        true -> 
            case (N rem Index == 0) and is_prime(Index) of
                true -> [Index | factor(N, Index+1)];
                false -> factor(N, Index + 1)
            end;
        false -> 
            []
    end.

factor(N) -> factor(N, 1).

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
        
-module(ex1).
-export([is_palindrome/1, is_an_anagram/2, factor/1, is_proper/1]).

is_palindrome(Str) -> 
    case (Str == "") or (string:len(Str) == 1) of
        true -> true;
        false -> 
            case string:to_lower(string:slice(Str, 0,1)) == string:to_lower(string:slice(Str, string:len(Str)-1, 1)) of
                true -> is_palindrome(string:trim(string:slice(Str, 1, string:len(Str)-2)));
                false -> false
            end
    end.

check_anagram(Str1, Str2) ->
    case Str1 == "" of
        true ->
            io:format(string:concat(Str2, ",")), %non funge
            case Str2 == "" of 
                true -> true;
                false -> false
            end;
        false -> 
            check_anagram(string:slice(Str1, 1), string:replace(Str2, string:slice(Str1, 0, 1), ""))
    end. 


is_an_anagram(_Str, [], C) -> C;
is_an_anagram(Str, [H|Tl], C) ->
    case check_anagram(Str, H) of
        true -> is_an_anagram(Str, Tl, C+1);
        false -> is_an_anagram(Str, Tl, C)
    end.

is_an_anagram(Str, Ls) -> 
    is_an_anagram(Str, Ls, 0).

is_prime(N) -> is_prime(N, 2).
is_prime(N, I) -> 
    case N > I of 
        true -> 
            case N rem I == 0 of 
                true -> false;
                false -> is_prime(N, I+1)
            end;
        false -> true
    end.

aux_factor(V, Index, Ls) -> 
    case V < Index/2 of 
        true -> Ls;
        false -> 
            case V rem Index == 0 of 
                true -> 
                    case is_prime(Index) of
                        true -> aux_factor(V, Index+1, [Index|Ls]);
                        false -> aux_factor(V, Index+1, Ls)
                    end;
                false -> aux_factor(V, Index+1, Ls)
            end
    end.
factor(V) -> aux_factor(V, 1, []).

sum([H|Tl]) -> H + sum(Tl);
sum([]) -> 0.

get_divisors(N) -> get_divisors(N, 1, []).
get_divisors(N, Index, Ls) ->
    case N > Index of 
        true ->
            case N rem Index == 0 of 
                true -> get_divisors(N, Index+1, [Index|Ls]);
                false -> get_divisors(N, Index+1, Ls)
            end;
        false -> Ls
        end.

is_proper(V) -> sum(get_divisors(V)) == V.
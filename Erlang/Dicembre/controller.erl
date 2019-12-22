-module(controller).
-export([start/1, is_prime/1]).
-import(sieve, [create_sieve/1]).

is_prime(N, Index) ->
    case (N/2) + 1 > Index of
        true ->
            case N rem Index == 0 of
                true -> false;
                false -> is_prime(N, Index+1)
            end;
        false -> true
    end.
is_prime(N) -> 
    case N < 2 of 
        true -> true; 
        false -> is_prime(N, 2)
    end.

get_n_primes(N, N, Ls) -> Ls;
get_n_primes(N, Index, Ls) ->
    case is_prime(Index) of
        true -> get_n_primes(N, Index+1, lists:append([Index], Ls));
        false -> get_n_primes(N, Index+1, Ls)
    end.
get_n_primes(N) -> lists:reverse(get_n_primes(N, 1, [])).

start(N) ->
    Prime_list = get_n_primes(N),
    First_sieve = sieve:create_sieve(Prime_list),
    S = self(),
    receive
        {new, N, From} ->
            First_sieve ! {new, N, From};
        {res, Val, From} ->
            From ! {result, Val}
    end.    
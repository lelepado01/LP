-module(sieve).
-export([create_sieve/1]).

create_other_sieve([H], First, Next) ->
    Pid = spawn(fun() -> sieve_wait(H, First, Next)end),
    First ! {next, Pid};
create_other_sieve([H|Tl], First, Next) -> 
    Pid = spawn(fun() -> sieve_wait(H, First, Next)end), 
    create_other_sieve(Tl, First, Pid).

create_sieve([H|Primes]) ->
    register(first, spawn(fun() -> fs_sieve_wait(H) end)),
    create_other_sieve(Primes, first).

sieve_wait(Prime, First, Next) ->
    receive
        {pass, N} ->
            case N > Prime of
                true -> Next ! {pass, N};
                false ->
                    case N == Prime of
                        true -> First ! {res, true};
                        false -> First ! {res, false} 
                    end
            end
    end, 
    sieve_wait(Prime, First, Next).

fs_sieve_wait(Prime) ->
    receive
        {next, Next} ->
            fs_sieve_wait(Prime, Next)
    end.
fs_sieve_wait(Prime, Next) ->
    receive
        {new, N, From} ->
            case N > Prime of
                true -> Next ! {pass, N};
                false ->
                    case N == Prime of
                        true -> From ! {res, true};
                        false -> From ! {res, false} 
                    end
            end, 
            fs_sieve_wait(Prime, Next);
        {pass, _} ->
            controller ! {res, "Too Large"}, 
            fs_sieve_wait(Prime, Next);
        {res, N} ->
            controller ! {res, N}, 
            fs_sieve_wait(Prime, Next)
    end.
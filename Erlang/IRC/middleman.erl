-module(middleman).
-export([start/1]).

start(P) -> register(mm, self()), mm_wait(P, []).

mm_wait(P, L) -> 
    receive
        {send, M} -> {server, 'server@MBP-di-Gabriele'} ! {send, M, P}, mm_wait(P, L);
        {new, M} -> mm_wait(P, lists:append([M], L));
        {refresh} -> P ! {refresh, L}, mm_wait(P, []);
        {disconnect} -> {server, 'server@MBP-di-Gabriele'} ! {disconnect, node()}
    end.
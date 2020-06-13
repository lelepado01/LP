-module(hypercube).
-export([create/0, grey/1, hamiltonian/2]).

grey(4) -> ["0000","0001","0011","0010","0110","0111","0101","0100","1100","1101","1111","1110","1010","1011","1001","1000"].

create() -> 
    Pids = spawn_list(grey(4)), 
    send_neighs(Pids), 
    register(server, spawn(fun() -> server_wait(Pids) end)).

server_wait(Ls) -> 
    receive
        {get, L, Src} -> {_, P} = lists:keyfind(L, 1, Ls), Src ! {ret, P}, server_wait(Ls); 
        {stop} -> io:format("Server Stopping\n")
    end.

spawn_list([]) -> [];
spawn_list([L|T]) -> [{L, spawn(fun() -> node_wait(L) end)}]++spawn_list(T).

send_neighs(Ls) -> lists:map(fun({L, P}) -> P ! {neighs, get_neighs(L, Ls)} end, Ls).

get_neighs(L, Ls) -> 
    Tags = ["0001","0010","0100","1000"], 
    Neighs = lists:map(fun(X) -> strxor(X, L) end, Tags),
    lists:map(fun(X) -> lists:keyfind(X, 1, Ls) end, Neighs).

strxor([], []) -> [];
strxor([C1| T1], [C2| T2]) -> [(C1 bxor C2)+$0]++strxor(T1, T2). 

node_wait(L) -> 
    receive
        {neighs, Ls} -> io:format("The process labeled ~p just started\n", [L]), node_wait(L, Ls)
        after 1000 -> timeout
    end.

node_wait(L, Ls) -> 
    receive
        {msg, M, [N|T]} -> 
            io:format("Received: ~p\n ", [M]),
            {_, P} = lists:keyfind(N, 1, Ls), 
            io:format("~p, ~p\n", [N, P]),
            P ! {msg, M, T}, 
            node_wait(L, Ls)
    end.

hamiltonian(M, [L|R]) -> 
    server ! {get, L, self()},
    receive 
        {ret, P} -> P ! {msg, M, R}
        after 1000 -> timeout
    end.
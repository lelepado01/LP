-module(joseph).
-export([joseph/2]).

create_node(1) ->
    Next = ring,
    receive
         ->
            
    end;
create_node(N) ->
    Next = spawn(fun() -> create_node(N-1) end),
    receive
         ->
            
    end.


joseph(N, M) ->
    register(ring, spawn(fun() -> create_node(N) end)).
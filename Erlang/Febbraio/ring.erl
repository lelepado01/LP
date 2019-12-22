-module(ring).
-export([start/2, send_message/1, send_message/2, stop/0]).

% come fare ring:
%   fun() start() che crea i primo processo registrato
%   il primo processo ha fun create, che crea Next process e poi mette in receive il processo attuale, che adesso sa chi è il processo successivo
%   il successivo è creato con la stessa fun create(), che fa la stessa cosa
%   l'ultimo processo ha un loop diverso che reindirizza al primo, per chiudere l'anello.
%    


start(N, Ls) ->
    register(ring, spawn(fun() -> create(N, Ls, self()) end)), 
    receive
        {ready} -> ok
    end.

stop() ->
    ring ! {command, stop}.

create(1, [H|_], From) ->
    From ! {ready}, 
    loop_last(ring, H);
create(N, [H|Tl], From) -> 
    Next = spawn_link(fun() -> create(N-1, Tl, From) end),
    loop(Next, H).

send_message(Msg) ->
    ring ! {command, message, {Msg, 1}}.
send_message(Msg, Times) ->
    ring ! {command, message, {Msg, Times}}.

loop(Next, F) ->
    receive
        {command, stop} ->
            Msg = {command, stop},
            Next ! Msg, 
            ok;
        {command, message, {Msg, Times}} ->
            Next ! {command, message, {F(Msg), Times}},
            loop(Next, F)
    end.

loop_last(Next, F) ->
    receive
        {command, stop} ->
            exit(normal), 
            unregister(ring);
        {command, message, {Msg, 1}} ->
            io:format("~p", [F(Msg)]),
            loop(Next, F);
        {command, message, {Msg, Times}} ->
            Next ! {command, message, {F(Msg), Times-1}},
            loop_last(Next, F)
    end.
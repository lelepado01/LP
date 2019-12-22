-module(dstore).
-export([start/0, lookup/1, insert/2, stop/0]).

store_loop() ->
    receive
        {From, {insert, V, N}} ->
            put(V, N),
            From ! {reply, "Added"},
            store_loop();
        {From, {lookup, N}} ->
            From ! {reply, {get(N), N}},
            store_loop();
        {From, {stop}} ->
            From ! {reply, "Stopped"}
    end.

start() ->
    register(store, spawn(fun() -> store_loop() end)).

rcv(Q) ->
    store ! {self(), Q},
    receive
        {reply, Reply} -> Reply
    end.

stop() ->
    rcv(stop).

lookup(Key) ->
    rcv({lookup, Key}).

insert(Key, V) ->
    rcv({insert, Key, V}).

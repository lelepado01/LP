-module(ring).
-export([start/3]).

loop() ->
    receive
        {msg, Msg} ->
            io:format("Process: ~p, printed message ~p\n", [self(), Msg]),
            loop();
        {kill} ->
            ok
    end.

controller_wait(Pid_list) ->
    receive
        {print, Msg, From} ->
            lists:foreach(fun(El) -> El ! {msg, Msg} end, Pid_list),
            From ! {done}, 
            controller_wait(Pid_list);
        kill ->
            lists:foreach(fun(El) -> El ! {kill} end, Pid_list)
    end.

createProcesses(N, N, Ls) -> Ls;
createProcesses(N, Index, Ls) ->
    createProcesses(N, Index+1, lists:append([spawn(fun() -> loop() end)], Ls)).
createProcesses(N) -> createProcesses(N, 0, []).

send_in_loop(M, M, _) ->
    controller ! kill;
send_in_loop(M, Index, Msg) ->
    From = self(),
    controller ! {print, Msg, From},
    receive
        {done} -> send_in_loop(M, Index+1, Msg)
    end. 

send_in_loop(M, Msg) ->
    send_in_loop(M, 0, Msg).

start(N, M, Msg) ->
    Pid_list = createProcesses(N),
    register(controller, spawn(fun() -> controller_wait(Pid_list) end)),
    send_in_loop(M, Msg).
-module(ex3).
-export([start/1, send/2, kill/1, stop/0, list/0]).

start(N) ->
    register(master, spawn(fun() -> ms_wait(N, []) end)).

slave_wait() ->
    receive
        {print} ->
            io:format("~p\n", [self()]), 
            slave_wait();
        {send, M} -> 
            io:format("~p\n", [M]), 
            slave_wait();
        {quit} -> io:format("Slave Quitting, ~p\n", [self()])
    end.

list_length([_|Tl]) -> list_length(Tl) + 1;
list_length([]) -> 0.

fill_list(N, Ls) ->
    case list_length(Ls) < N of
        true -> fill_list(N, lists:append([spawn(fun() -> slave_wait() end)], Ls));
        false -> Ls
    end.

send_remove(N, Pid_list) ->
    send_remove(N, Pid_list, 0, []).
send_remove(N, [H|Tl], I, Mod_list) ->
    case N == I of
        true ->
            H ! {quit},
            lists:append(Mod_list, Tl);
        false ->
            send_remove(N, Tl, I+1, lists:append([H], Mod_list))
    end;
send_remove(_, [], _, Mod_list) ->
    Mod_list.

ms_wait(Ns, Pid_list) ->
    case list_length(Pid_list) < Ns of
        true -> New_Pid_list = fill_list(Ns, Pid_list);
        false -> New_Pid_list = Pid_list
    end, 
    receive
        {list} ->
            io:format("Listing all Slave Processes\n"),
            lists:map(fun(P) -> P ! {print} end, New_Pid_list),
            ms_wait(Ns, New_Pid_list);
        {quit} -> 
            io:format("Master Stopping\n"), 
            lists:map(fun(P) -> P ! {quit} end, New_Pid_list);
        {send, M, N} ->
            io:format("Master Received\n"), 
            case N >= Ns of 
                true ->
                    io:format("Invalid Number\n"),
                    ms_wait(Ns, New_Pid_list);
                false ->
                    lists:nth(N+1, New_Pid_list) ! {send, M}, 
                    ms_wait(Ns, New_Pid_list)
            end;
        {kill, N} ->
            case N >= Ns of
                true ->
                    io:format("Invalid Number\n"),
                    ms_wait(Ns, New_Pid_list);
                false ->
                    io:format("Master Killing Slave\n"),
                    Mod_pid_list = send_remove(N, New_Pid_list),
                    ms_wait(Ns, Mod_pid_list)
            end
    end.

send(M, N) ->
    io:format("Sending Message ~p\n", [M]),
    master ! {send, M, N}.

kill(N) ->
    master ! {kill, N}.

list() ->
    master ! {list}.

stop() ->
    master ! {quit}.

-module(tempsys).
-export([start/0]).

start() -> register(sys, spawn(fun() -> sys_start() end)).

sys_start() ->
    L1 = 
        [
            {from, 'C', fun(X) -> X end},
            {from, 'F', fun(X) -> (X-32)*5/9 end}, 
            {from, 'K', fun(X) -> X - 273.15 end},  
            {from, 'R', fun(X) -> 5/9*X - 273.15 end}, 
            {from, 'De', fun(X) -> 100- 2/3*X end}, 
            {from, 'N', fun(X) -> 100*X/33 end}, 
            {from, 'Re', fun(X) -> 5*X/4 end}, 
            {from, 'Ro', fun(X) -> (X - 7.5)*40/21 end}
        ],
    L2 = 
        [
            {to, 'C', fun(X) -> X end},
            {to, 'F', fun(X) -> 9/5*X +32 end}, 
            {to, 'K', fun(X) -> X + 273.15 end},  
            {to, 'R', fun(X) -> (X + 273.15) *9/5 end}, 
            {to, 'De', fun(X) -> 3/2*(100-X) end}, 
            {to, 'N', fun(X) -> 33*X/100 end}, 
            {to, 'Re', fun(X) -> 4*X/5 end}, 
            {to, 'Ro', fun(X) -> 21*X/40 + 7.5 end}
        ],

    lists:map(fun({I, S, Pid}) -> put({I, S}, Pid) end, get_list(L1)), 
    lists:map(fun({I, S, Pid}) -> put({I, S}, Pid) end, get_list(L2)), 
    sys_wait().

sys_wait() ->
    receive
        {from, F, to, T, V, Src} -> get({from, F}) ! {from, T, V, Src}, sys_wait();
        {get, to, S,  Src} -> Src ! {ret, get({to, S})}, sys_wait()
    end.

get_list([]) -> [];
get_list([{I, S, F}|Tl]) -> lists:append([{I, S, spawn(fun() -> slave_wait(F) end)}], get_list(Tl)). 

slave_wait(F) -> 
    receive
        {from, S, V, Src} -> 
            sys ! {get, to, S, self()},
            receive
               {ret, P} -> P ! {to, self(), F(V), Src} 
               after 1000 -> io:format("Timeout\n")
            end, 
            slave_wait(F);
        {to, Src, V, Src2} -> Src ! {ret, F(V), Src2}, slave_wait(F);
        {ret, V, Src} -> Src ! {ret, V}, slave_wait(F)
    end.
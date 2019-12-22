-module(coverter_test).
-export([start/0]).

Pid = spawn(converter, t_converter, []).
Pid ! {toC, 0}.
Pid ! {toF, 0}.
Pid ! {stop}.
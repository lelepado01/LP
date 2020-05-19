-module(client).
-export([is_prime/1, quit/0]).

is_prime(N) -> 
    {controller, 'cont@MBP-di-Gabriele'} ! {new, N, self()},
    receive 
        {result, R} -> io:format("Result: ~p\n", [R])
        after 2000 -> io:format("Timeout\n")
    end.

quit() -> {controller, 'cont@MBP-di-Gabriele'} ! {quit}.
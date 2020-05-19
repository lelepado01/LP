-module(hebrew).
-export([hebrew_wait/2]).

hebrew_wait(Next, Index) ->
    receive
        {kill, K, I} when K-2 == I -> Next ! {die, self(), K}, hebrew_wait(Next, Index);
        {die, Prev, K} -> Prev ! {died, Next, K};
        {kill, _, _} when Next == self() -> controller ! {survivor, Index};
        {kill, K, I} -> Next ! {kill, K, I+1}, hebrew_wait(Next, Index);
        {died, N, K} -> N ! {kill, K, 0}, hebrew_wait(N, Index)
    end.
-module(generator).
-export([column/4, create_list/3]).

column(N, M, C, Src) -> Src ! {col, C, create_list(N, M, C)}.

create_list(N, M, C) -> append_seq(trunc(math:pow(M, N-C)), 1, M, C).

append_seq(N, N, M, C) -> append_rep(M, 1, M, C);
append_seq(N, I, M, C) -> lists:append(append_rep(M, 1, M, C), append_seq(N, I+1, M, C)).

append_rep(N, N, M, C) -> append_num(trunc(math:pow(M, C-1)), 1, N);
append_rep(N, I, M, C) -> lists:append(append_num(trunc(math:pow(M, C-1)), 1, I), append_rep(N, I+1, M, C)).

append_num(Max, Max, N) -> [N];
append_num(Max, I, N) -> lists:append([N], append_num(Max, I+1, N)).
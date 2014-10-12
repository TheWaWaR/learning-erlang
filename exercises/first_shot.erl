
-module(first_shot).

-export([fac/1, len/1, reverse/1]).


fac(0) -> 1;
fac(N) when N > 0 -> N * fac(N-1).


%% len([]) -> 0; 
%% len([_|T]) -> 1+len(T).

len(L) -> tail_len(L, 0).
tail_len([], Acc) -> Acc; 
tail_len([_ | T], Acc) -> tail_len(T, Acc+1).


reverse(L) -> tail_reverse(L, []).
tail_reverse([], Acc) -> Acc;
tail_reverse([H|T], Acc) -> tail_reverse(T, [H|Acc]).

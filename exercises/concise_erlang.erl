
%% http://www.cis.upenn.edu/~matuszek/General/ConciseGuides/concise-erlang.html
-module(concise_erlang).
-export([main/0]).


main() ->
    Hello = "hello",
    io:fwrite("Hello = ~s\n", [Hello]),
    io:fwrite("========================================\n").
    



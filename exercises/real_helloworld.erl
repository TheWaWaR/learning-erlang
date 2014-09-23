
%% http://egarson.blogspot.jp/2008/03/real-erlang-hello-world.html

-module(hello1).
-export([start/0]).


start() ->
    spawn(fun() -> loop() end).

loop() ->
    receive
        hello ->
            io:fwrite("Hello World~n"),
            loop();
        goodbye ->
            io:fwrite("Good bye~~~n")
    end.

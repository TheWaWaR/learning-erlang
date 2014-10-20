
-module(road).
-export([main/1]).


main([Filename]) ->
    {ok, Bin} = file:read_file(Filename),
    io:format("Binary: ~p~n", [Bin]),
    Items = parse_items(Bin),
    io:format("Items: ~p~n", [Items]),
    {Opt1, Opt2} = lists:foldl(fun best_path/2, {{0, []}, {0, []}}, Items),
    {_Dis, Path} = if hd(element(2, Opt1)) =/= {x, 0} -> Opt1;
                      hd(element(2, Opt2)) =/= {x, 0} -> Opt2
                   end,
    io:format("Best path: ~p~n", [lists:reverse(Path)]),
    erlang:halt(0).


parse_items(Bin) when is_binary(Bin) ->
    parse_items(string:tokens(binary_to_list(Bin), "\r\n\t "));
parse_items(Tokens) when is_list(Tokens) ->
    val_grp(Tokens, []).

val_grp([], Items) ->
    lists:reverse(Items);
val_grp([A, B, X| Rest], Items) ->
    val_grp(Rest, [{list_to_integer(A), list_to_integer(B), list_to_integer(X)}|Items]).

best_path({A, B, X}, {{DisA, PathA}, {DisB, PathB}}) ->
    OptA1 = {DisA + A, [{a, A} | PathA]},
    OptA2 = {DisB + X + B, [{x, X}, {b, B} | PathB]},
    OptB1 = {DisB + B, [{b, B} | PathB]},
    OptB2 = {DisA + X + A, [{x, X}, {a, A} | PathA]},
    {erlang:min(OptA1, OptA2), erlang:min(OptB1, OptB2)}.
    

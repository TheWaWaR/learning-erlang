
%% Reverse Polish Notation Calculator.

-module(rpn_calc).

-export([calc/1]).


calc(Input) ->
    [Res] = lists:foldl(fun calc/2, [], string:tokens(Input, " ")),
    Res.
    
calc(X, Acc) ->
    case X of
        "+" ->
            [B, A | Rest] = Acc,
            [A + B | Rest];
        "-" ->
            [B, A | Rest] = Acc,
            [A - B | Rest];
        "*" ->
            [B, A | Rest] = Acc,
            [A * B | Rest];
        "/" ->
            [B, A | Rest] = Acc,
            [A / B | Rest];
        _ ->
            [convert(X)|Acc]
    end.

convert(X) ->
    case string:to_float(X) of
        {error, no_float} ->
            list_to_integer(X);
        {F, _Rest} -> F
    end.

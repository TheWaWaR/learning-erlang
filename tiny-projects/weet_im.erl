
%% > im.ahorn.me
%% (Room, Admin, User, Visitor) chat stuff.

-module(weet_im).

-export([start/1]).

start(Port) ->
    case gen_tcp:listen(Port, [binary,
                               {packet, 0},
                               {active, false}]) of
        {ok, LSock} ->
            io:fwrite("Listen ok: ~p~n", [LSock]),
            accept_loop(LSock);
        {error, Reason} ->
            io:fwrite("Listen error: ~p~n", [Reason])
    end.



accept_loop(LSock) ->
    case gen_tcp:accept(LSock) of
        {ok, Sock} ->
            io:fwrite("Accept one: ~p~n", [Sock]),
            spawn(fun() -> do_recv(Sock) end);
        {error, Reason} ->
            io:fwrite("Accept error: ~p~n", [Reason])
    end,
    accept_loop(LSock).


do_recv(Sock) ->
    case gen_tcp:recv(Sock, 0 ) of
        {ok, Packet} ->
            io:fwrite("Receive packet: ~p => ~p~n", [Sock, Packet]),
            %% PackSend = io_lib:format("Your input: <~s>~n",
            %%                          [re:replace(Packet, "(^\\s+)|(\\s+$)", "",
            %%                                      [global, {return, list}])]),
            CharList = binary_to_list(Packet),
            PackSend = io_lib:format(">> Your input: <~s>~n",
                                     [lists:sublist(CharList, length(CharList)-2)]),
            case proc_packet(Sock, PackSend) of
                error ->
                    gen_tcp:close(Sock);
                ok ->
                    do_recv(Sock)
            end;
        {error, Reason} ->
            io:fwrite("Receive error: ~p =>  ~p~n", [Sock, Reason])
    end.


proc_packet(Sock, Packet) ->
    case gen_tcp:send(Sock, Packet) of
        {error, Reason} ->
            io:fwrite("Send error: ~p => ~p~n", [Sock, Reason]),
            error;
        ok ->
            ok
    end.
            

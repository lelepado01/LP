-module(ex1).
-export([say/1, say/0]).

say() ->
    io:format("One for Me, One for You\n").

say(Name) ->
    io:format("One for ~p, One for Me\n", [Name]).
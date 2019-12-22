-module(ex2).
-export([string_to_exp/1, evaluate/1]).

% ((2+3)-4)
% (2+(3+(4+1)))

get_char(Str, Index) ->
    string:sub_string(Str, Index, Index).

operate(Op3, Operation, Op4) ->
    {Op1, _} = string:to_integer(Op3),
    {Op2, _} = string:to_integer(Op4),
    if
        Operation == "+" ->
            Op1 + Op2;
        Operation == "-" ->
            Op1 - Op2;
        Operation == "*" ->
            Op1 * Op2;
        true -> io:format("Operation not Supported")
    end.

is_digit(Char) ->
    case (string:equal(Char,"(") or string:equal(Char,")") or string:equal(Char,"+") or string:equal(Char,"-") or string:equal(Char ,"*")) of
        true -> false;
        false -> true
    end.

is_operator(Char) ->
    case (string:equal(Char,"+") or string:equal(Char,"-") or string:equal(Char ,"*")) of
        true -> true;
        false -> false
    end.

read_expr(Str, Index) ->
    case is_operator(get_char(Str, Index+1)) of
        true -> operate(get_char(Str, Index), get_char(Str, Index+1), read_expr(Str, Index+2));
        false ->
            case is_digit(get_char(Str, Index)) of
                true -> get_char(Str, Index);
                false ->
                    case get_char(Str, Index) == "(" of
                        true ->
                            operate(read_expr(Str, Index +1), get_char(Str, Index + 2), read_expr(Str, Index + 3));
                        false ->
                            io:format("Invalid\n")
                    end
            end
    end.


string_to_exp(Str) -> 
    read_expr(Str, 1).

evaluate(_Exp) -> 0.
-module(test).
-export([foo/0]).
-export([bar/1]).

foo()->
	io:format("Hello from foo ~p~n",[self()]),
	Mat1 = {{1,2,3},{4,5,6},{7,8,9}},
	Mat2 = {{1},{2},{3}},
	matrix_server:start_server(),
	matrix_server ! {self(), igor, {multiple, Mat1, Mat2}},
	receive
		{igor, Result} ->
			Result
	end.
			
	
bar(Pid) ->
	io:format("Hello~p~n",Pid).

%daafasd
%Mat1 = {{1,2,3},{4,5,6},{7,8,9}}
%Mat2 = {{1},{2},{3}}
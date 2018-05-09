-module(test).
-export([start/0]).
-export([mult/0]).
-export([version/0]).
-export([upgrade/0]).
-export([fail/0]).
-export([shutdown/0]).


start() ->
	spawn(matrix_server, start_server, []).

start2() ->
	compile:file(matrix_server),
	compile:file(matrix_server_supervisor),
	compile:file(matrix),
	compile:file(vectors),
	
	code:purge(matrix_server),
	code:purge(matrix_server_supervisor),
	code:purge(matrix),
	code:purge(vectors),
	
	code:load_file(matrix_server),
	code:load_file(matrix_server_supervisor),
	code:load_file(matrix),
	code:load_file(vectors),
	
	spawn(matrix_server, start_server, []).

	
mult()->
	io:format("Hello from test_mult ~p~n",[self()]),
	Mat1 = {{1,2,3},{4,5,6},{7,8,9}},
	Mat2 = {{1,5,6},{2,5,6},{3,5,6}},
	matrix_server ! {self(), 10, {multiple, Mat1, Mat2}},
	receive
		{MsgRef, Result} ->
			io:format("test:mult got message from MsgRef==~p~n",[MsgRef]),
			Result
	end.

	
version() ->
	matrix_server ! {self(), house, get_version},
	receive
		{Var, Version} ->
			{Var, Version}
	end.
	

upgrade() ->
	matrix_server ! sw_upgrade.

shutdown() ->
	matrix_server ! shutdown.

fail() ->
	matrix_server ! fail.
	
%daafasd
%Mat1 = {{1,2,3},{4,5,6},{7,8,9}}
%Mat2 = {{1},{2},{3}}

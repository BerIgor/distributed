-module(matrix_server_supervisor).

-export([matrix_server_start/0]).


matrix_server_start() ->
	io:format("hello from matrix_server_start ~p~n", [self()]),
	process_flag(trap_exit, true),
	Server_pid = spawn_link(matrix_server, loop, []),
	%Server_pid = spawn_link(fun()->matrix_server:loop() end),
	register(matrix_server, Server_pid),
	receive
		{'EXIT', Server_pid, normal} -> fuck; %TODO: RETURN WHAT?
		{'EXIT', Server_pid, shutdown} -> fuck; %TODO: RETURN WHAT?
		{'EXIT', Server_pid, _} -> fuck %matrix_server_start()
	end.

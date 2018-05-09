-module(matrix_server_supervisor).

-export([matrix_server_start/0]).


matrix_server_start() ->
	process_flag(trap_exit, true),
	Server_pid = spawn_link(matrix_server, loop, []),
	register(matrix_server, Server_pid),
	receive
		{'EXIT', Server_pid, normal} -> ok;
		{'EXIT', Server_pid, shutdown} -> ok;
		{'EXIT', Server_pid, _} -> 
			matrix_server_start()
	end.

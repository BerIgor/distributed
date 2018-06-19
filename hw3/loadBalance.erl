-module(loadBalance).
-export([startServers/0, stopServers/0, numberOfRunningFunctions/1, calcFun/3]).

startServers()->
	spawn(loadBalance_sup, start_link, []).
	
stopServers()->
	exit(loadBalance_sup, normal).
	
numberOfRunningFunctions(ServerNumber)->
	Server = case ServerNumber of
		1 ->
			server1;
		2 ->
			server2;
		3 ->
			server3;
		_ ->
			exit(self(), normal)
	end,
	gen_server:call(Server, {number_of_funs}).

calcFun(PID, Function, MsgRef)->
	Server = getLeastBusyServer(),
	gen_server:call(Server, {PID, Function, MsgRef}).
	
%%%%%%%

getLeastBusyServer()->
	Server1_count = numberOfRunningFunctions(1),
	Server2_count = numberOfRunningFunctions(2),
	Server3_count = numberOfRunningFunctions(3),
	
	if
	Server1_count <= Server2_count andalso Server1_count <= Server3_count ->
		server1;
	Server2_count <= Server1_count andalso Server2_count <= Server3_count ->
		server2;
	true ->
		server3
	end.
	
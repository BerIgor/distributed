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
	
	Server ! {self(), number_of_funs},
	receive
		Pattern1 [when GuardSeq1] ->
			Body1;
	after
		ExprT ->
			BodyT
	end
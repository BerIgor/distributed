-module(loadBalance_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link()->
	% starts the supervisor on the local machine with with registered name ?MODULE (loadBalance_sup)
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([])->
	Server1 = {server1,{fun_server, start_link, [server1]},permanent, brutal_kill, worker, [fun_server]},
	Server2 = {server2,{fun_server, start_link, [server2]},permanent, brutal_kill, worker, [fun_server]},
	Server3 = {server3,{fun_server, start_link, [server3]},permanent, brutal_kill, worker, [fun_server]},
	{ok,{{one_for_one,1,1}, [Server1, Server2, Server3]}}.
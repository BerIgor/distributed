-module(fun_server).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,terminate/2, code_change/3]).

start_link(Name)->
	gen_server:start_link({local, Name}, ?MODULE, [], []).

init([])->
	State = 0,
	{ok, State}.

handle_call({number_of_funs}, From, State)->
	{reply, {number_of_funs, State}, State}.

handle_call({PID, Function, MsgRef}, From, State)->
	spawn_link(?MODULE, calc_fun_and_respond, [PID, Function, MsgRef]),
	State = State + 1.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, Extra) -> {ok, State}.


%%%%%%%%
calc_fun_and_respond(PID, Function, MsgRef)->
	Result = Function(),
	PID ! {MsgRef, Result}.
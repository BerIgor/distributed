-module(funServer).
-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,terminate/2, code_change/3]).
-export([calc_fun_and_respond/3]).

start_link(Name)->
	io:format("funServer starting~n"),
	gen_server:start_link({local, Name}, ?MODULE, [], []).

init([])->
	process_flag(trap_exit, true),
	State = 0,
	{ok, State}.

handle_call(number_of_funs, _From, State)->
	{reply, State, State};
handle_call({PID, Function, MsgRef}, _From, State)->
	spawn_link(?MODULE, calc_fun_and_respond, [PID, Function, MsgRef]),
	State = State + 1,
	ok.

handle_cast(_Msg, State)-> {noreply, State}.

% When a child process exits, it sends us a message of the tuple below
handle_info({'EXIT',_PID,_Reason}, State)->
	State = State - 1,
	{noreply, State};
handle_info(_Info, State)->{noreply, State}.
terminate(_Reason, _State)-> ok.
code_change(_OldVsn, State, _Extra)-> {ok, State}.


%%%%%%%%
calc_fun_and_respond(PID, Function, MsgRef)->
	Result = Function(),
	PID ! {MsgRef, Result}.
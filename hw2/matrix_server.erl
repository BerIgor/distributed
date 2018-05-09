-module(matrix_server).
-export([start_server/0]).
%-export([shut_down/0]).
-export([mult/2]).
%-export([get_version/0]).
%-export([explanation/0]).
%-export([assemble_matrix_loop/3]).

start_server() ->
	restarter().


mult(Mat1, Mat2) ->
	io:format("hello from mult~p~n", [self()]),
	ResMat_RowCount = tuple_size(Mat1),
	ResMat_ColCount = tuple_size(element(1, Mat2)),
	ZeroMat = matrix:getZeroMat(ResMat_RowCount, ResMat_ColCount),
%	Assembler_pid = spawn(?MODULE, assemble_matrix_loop, [ZeroMat, ResMat_RowCount*ResMat_ColCount, self()]),
	Self = self(),
	Assembler_pid = spawn(fun()-> assemble_matrix_loop(ZeroMat, ResMat_RowCount*ResMat_ColCount, Self) end),
	% Create processes to calculate multiplications
	_ = [spawn(fun()-> vectors:getMultMatrixElement(Assembler_pid, RowNum, ColNum, Mat1, Mat2) end) || RowNum <- lists:seq(1,ResMat_RowCount), ColNum <- lists:seq(1,ResMat_ColCount)],
	receive
		{Assembler_pid, ResMat} -> 
			ResMat
		after 6000 -> %TODO: REMOVE THIS TIMEOUT?
			io:format("Timeout~n")
	end.


%%%%%%%%%%%%%%%%%%%%%%%% Private functions

assemble_matrix_loop(Mat, Element_count, Parent_pid) when Element_count == 0 ->
	io:format("hello from assemble_matrix_loop with 0~n"),
	Parent_pid ! {self(), Mat};
assemble_matrix_loop(Mat, Element_count, Parent_pid) ->
	io:format("hello from assemble_matrix_loop with~p~n", [Element_count]),
	receive
		{RowNum, ColNum, Value} ->
			NewMat = matrix:setElementMat(RowNum,ColNum,Mat, Value),
			assemble_matrix_loop(NewMat, Element_count-1, Parent_pid)
	end.


restarter() ->
	process_flag(trap_exit, true),
	Pid = spawn_link(?MODULE, loop, []),
	register(matrix_server, Pid),
	receive
		{'EXIT', Pid, normal} -> fuck; %TODO: RETURN WHAT?
		{'EXIT', Pid, shutdown} -> fuck; %TODO: RETURN WHAT?
		{'EXIT', Pid, _} -> restarter()
	end.


loop() ->
	receive
		{Pid, MsgRef, {multiple, Mat1, Mat2}} -> % multiplication request
			Pid ! {MsgRef, mult(Mat1, Mat2)},
			loop();
		shutdown -> % perform shutdown
			%TODO: FINISH
			loop();
		{Pid, MsgRef, get_version} -> % return current version
			%TODO: FINISH
			loop();
		sw_upgrade -> % update software
			%TODO: FINISH
			loop()
	end.


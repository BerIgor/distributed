-module(matrix_server).
-export([start_server/0]).
%-export([shut_down/0]).
-export([mult/2]).
%-export([get_version/0]).
%-export([explanation/0]).


start_server() ->
	restarter().


mult(Mat1, Mat2) ->
	io:format("hello from mult"),
	ResMat_RowCount = tuple_size(Mat1),
	ResMat_ColCount = tuple_size(element(1, Mat2)),
	Assembler_pid = spawn(?MODULE, assemble_matrix, [ResMat_RowCount, ResMat_ColCount, self()]),
	% Create processes to calculate multiplications
	_ = [spawn(fun()-> vectors:getMultMatrixElement(Assembler_pid, RowNum, ColNum, Mat1, Mat2) end) || RowNum <- lists:seq(1,ResMat_RowCount), ColNum <- lists:seq(1,ResMat_ColCount)],
	receive
		{Assembler_pid, ResMat} -> ResMat;
		after 5000 ->
			io:format("Timeout")
	end.


%%%%%%%%%%%%%%%%%%%%%%%% Private functions


assemble_matrix(RowCount, ColCount, Parent_pid) ->
	io:format("hello from assemble_matrix"),
	ResultMatrix = matrix:getZeroMat(RowCount, ColCount),
	Element_count = RowCount*ColCount,
	assemble_matrix_loop(ResultMatrix, Element_count, Parent_pid).
	
assemble_matrix_loop(Mat, 0, Parent_pid) ->
	io:format("hello from assemble_matrix_loop with 0"),
	Parent_pid ! {Parent_pid, Mat};
assemble_matrix_loop(Mat, Element_count, Parent_pid) ->
	io:format("hello from assemble_matrix_loop"),
	receive
		{RowNum, ColNum, Value} ->
			Mat = matrix:setElementMat(RowNum,ColNum,Mat, Value),
			assemble_matrix_loop(Mat, Element_count-1, Parent_pid)
	end.


restarter() ->
	process_flag(trap_exit, true),
	Pid = spawn_link(?MODULE, loop, []),
	register(matrix_server, Pid),
	receive
		{'EXIT', Pid, normal} -> ok; %TODO: RETURN WHAT?
		{'EXIT', Pid, shutdown} -> ok; %TODO: RETURN WHAT?
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


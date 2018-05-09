-module(matrix_server).

-export([start_server/0]).
-export([shutdown/0]).
-export([mult/2]).
-export([get_version/0]).
-export([loop/0]).

start_server() ->
	matrix_server_supervisor:matrix_server_start().

mult(Mat1, Mat2) ->
	ResMat_RowCount = tuple_size(Mat1),
	ResMat_ColCount = tuple_size(element(1, Mat2)),
	ZeroMat = matrix:getZeroMat(ResMat_RowCount, ResMat_ColCount),
	Self = self(),
	Assembler_pid = spawn(fun()-> assemble_matrix_loop(ZeroMat, ResMat_RowCount*ResMat_ColCount, Self) end),
	% Create processes to calculate multiplications
	_ = [spawn(fun()-> vectors:getMultMatrixElement(Assembler_pid, RowNum, ColNum, Mat1, Mat2) end) || RowNum <- lists:seq(1,ResMat_RowCount), ColNum <- lists:seq(1,ResMat_ColCount)],
	receive
		{Assembler_pid, ResMat} -> 
			ResMat
	end.
	
	
get_version() ->
	version_1.

	
shutdown() ->
	exit(self(), shutdown).

%%%%%%%%%%%%%%%%%%%%%%%% Private functions

assemble_matrix_loop(Mat, Element_count, Parent_pid) when Element_count == 0 ->
	Parent_pid ! {self(), Mat};
assemble_matrix_loop(Mat, Element_count, Parent_pid) ->
	receive
		{RowNum, ColNum, Value} ->
			NewMat = matrix:setElementMat(RowNum,ColNum,Mat, Value),
			assemble_matrix_loop(NewMat, Element_count-1, Parent_pid)
	end.


loop() ->
	receive
		{Pid, MsgRef, {multiple, Mat1, Mat2}} -> % multiplication request
			Pid ! {MsgRef, mult(Mat1, Mat2)},
			loop();
		shutdown -> % perform shutdown
			shutdown();
		{Pid, MsgRef, get_version} -> % return current version
			Pid ! {MsgRef, get_version()},
			loop();
		sw_upgrade -> % update software
			?MODULE:loop()
	end.


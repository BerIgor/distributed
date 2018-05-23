-module(matrix_server).

-export([start_server/0]).
-export([shutdown/0]).
-export([mult/2]).
-export([get_version/0]).
-export([explanation/0]).
-export([loop/0]).

start_server() ->
	spawn(matrix_server_supervisor,matrix_server_start,[]).

mult(Mat1, Mat2) ->
	ResMat_RowCount = tuple_size(Mat1),
	ResMat_ColCount = tuple_size(element(1, Mat2)),
	ZeroMat = matrix:getZeroMat(ResMat_RowCount, ResMat_ColCount),
	Self = self(),
	
	% Create a process to assemble the output matrix of its elements
	Assembler_pid = spawn(fun()-> assemble_matrix_loop(ZeroMat, ResMat_RowCount*ResMat_ColCount, Self) end),
	
	% Create processe for each element in the output matrix
	% Each process calculates the value for the specific element defines by its row and column number in the output matrix
	% Each process will send the calculated result of its element to the assembler process
	_ = [spawn(fun()-> vectors:getMultMatrixElement(Assembler_pid, RowNum, ColNum, Mat1, Mat2) end) || RowNum <- lists:seq(1,ResMat_RowCount), ColNum <- lists:seq(1,ResMat_ColCount)],
	
	% wait for the assembler to provide final calculated output matrix
	receive
		{Assembler_pid, ResMat} -> 
			ResMat
	end.
	
get_version() ->
	version_1.

shutdown() ->
	matrix_server ! shutdown.

explanation() ->
	{"Module's code can be current or old. Meaning, when updating (compiling + loading) to new code, then: the old code is DELETED, the current BECOMES OLD and the new code BECOMES CURRENT. Processes running deleted code are TERMINATED. So, if supervisor will be in same module as the server, then when the server will be updated more than once the first code version will be DELETED and the supervisor process will be TERMINATED (running first code version)"}.
	

loop() ->
	receive
		{Pid, MsgRef, {multiple, Mat1, Mat2}} -> % multiplication request
			Pid ! {MsgRef, mult(Mat1, Mat2)},
			loop();
		{Pid, MsgRef, get_version} -> % return current version
			Pid ! {MsgRef, get_version()},
			loop();
		shutdown -> % perform shutdown
			exit(self(), shutdown);
		sw_upgrade -> % update software
			?MODULE:loop()
	end.
	
	
%%%%%%%%%%%%%%%%%%%%%%%% Private functions

assemble_matrix_loop(Mat, Element_count, Parent_pid) when Element_count == 0 ->
	Parent_pid ! {self(), Mat};
assemble_matrix_loop(Mat, Element_count, Parent_pid) ->
	receive
		{RowNum, ColNum, Value} ->
			NewMat = matrix:setElementMat(RowNum,ColNum,Mat, Value),
			assemble_matrix_loop(NewMat, Element_count-1, Parent_pid)
	end.
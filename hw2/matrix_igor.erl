-module(matrix_igor).
-export([test/0]).
-export([mat_get_col/2]).

test() ->
	Mat1 = {{1,2,3},{4,5,6},{7,8,9}},
	mat_get_col(Mat1, 2).

%Mat is a tuple of tuples
mat_get_col(Mat, Col_num) ->
	mat_get_col2(tuple_to_list(Mat), Col_num, []).

mat_get_col2([Curr_row | Mat], Col_num, Col) ->
	Current_element = element(Col_num, Curr_row),
	mat_get_col2(Mat, Col_num, [Current_element|Col]).
	
	
% Ffrom the vector file
getRowVec(Index,Matrix) when is_tuple(Matrix) == true ->
	tuple_to_list(element(Index,Matrix)).

getColumnVec(Index,Matrix) when is_tuple(Matrix) == true ->
	ListOfRowTuples = tuple_to_list(Matrix),
	getColumnVec(Index,[],ListOfRowTuples).
getColumnVec(Index, CurrentVec, [NextRowTuple|RowTuples]) ->
	getColumnVec(Index, lists:append(CurrentVec, [element(Index,NextRowTuple)]), RowTuples);
getColumnVec(_,CurrentVec,[]) -> CurrentVec.
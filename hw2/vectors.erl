-module(vectors).
-import(lists,[nth/2]).
-import(lists,[append/2]).

-export([multVectors/2]).
-export([getRowVec/2]).
-export([getColumnVec/2]).
-export([getMultMatrixElement/4]).



getMultMatrixElement(Row,Column,Matrix1,Matrix2) ->
	multVectors(getRowVec(Row,Matrix1), getColumnVec(Column,Matrix2)).


multVectors(ListVec1,ListVec2) when is_list(ListVec1) == true , is_list(ListVec2) == true , length(ListVec1) == length(ListVec2) ->
	multVectors(ListVec1,ListVec2,0).
multVectors([Head1|List1], [Head2|List2], Sum) -> multVectors(List1, List2, Sum + Head1*Head2);
multVectors([],[],Sum) -> Sum.

getRowVec(Index,Matrix) when is_tuple(Matrix) == true ->
	tuple_to_list(element(Index,Matrix)).

getColumnVec(Index,Matrix) when is_tuple(Matrix) == true ->
	ListOfRowTuples = tuple_to_list(Matrix),
	getColumnVec(Index,[],ListOfRowTuples).
getColumnVec(Index, CurrentVec, [NextRowTuple|RowTuples]) ->
	getColumnVec(Index, lists:append(CurrentVec, [element(Index,NextRowTuple)]), RowTuples);
getColumnVec(_,CurrentVec,[]) -> CurrentVec.
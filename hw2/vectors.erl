-module(vectors).
-import(lists,[nth/2]).
-import(lists,[append/2]).

-export([multVectors/2]).
-export([getColumnVec/2]).


multVectors(TupleVec1,TupleVec2) when is_tuple(TupleVec1) == true , is_tuple(TupleVec1) == true , tuple_size(TupleVec1) == tuple_size(TupleVec2) ->
	multVectors(tuple_to_list(TupleVec1),tuple_to_list(TupleVec2),0).
multVectors([Head1|List1], [Head2|List2], Sum) -> multVectors(List1, List2, Sum + Head1*Head2);
multVectors([],[],Sum) -> Sum.


getColumnVec(Index,Matrix) when is_tuple(Matrix) == true ->
	ListOfRowTuples = tuple_to_list(Matrix),
	getColumnVec(Index,[],ListOfRowTuples).
getColumnVec(Index, CurrentVec, [NextRowTuple|RowTuples]) ->
	getColumnVec(Index, lists:append(CurrentVec, [element(Index,NextRowTuple)]), RowTuples);
getColumnVec(_,CurrentVec,[]) -> CurrentVec.
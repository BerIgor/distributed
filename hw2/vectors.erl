
-module(vectors).

-export([multVectors/2]).


multVectors(TupleVec1,TupleVec2) when is_tuple(TupleVec1) == true , is_tuple(TupleVec1) == true , tuple_size(TupleVec1) == tuple_size(TupleVec2) ->
	multVectors(tuple_to_list(TupleVec1),tuple_to_list(TupleVec2),0).
multVectors(List1,List2,Sum) -> Sum+List1*List2;
multVectors(Vec1,Vec2,Index,Sum) ->

.
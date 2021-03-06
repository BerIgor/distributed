-module(vectors).

-export([getMultMatrixElement/5]).

% Returns the element at (Row,Column) in the Matrix1*Matrix2 result matrix
getMultMatrixElement(From, Row,Column,Matrix1,Matrix2) ->
	Result = multVectors(tuple_to_list(matrix:getRow(Matrix1, Row)), tuple_to_list(matrix:getCol(Matrix2, Column))),
	From ! {Row, Column, Result}.

%%%%%%% Private functions	
	
% Multiplies two vectors
multVectors(ListVec1,ListVec2) when is_list(ListVec1) == true , is_list(ListVec2) == true , length(ListVec1) == length(ListVec2) ->
	multVectors(ListVec1,ListVec2,0).
multVectors([Head1|List1], [Head2|List2], Sum) ->
	multVectors(List1, List2, Sum + Head1*Head2);
multVectors([],[],Sum) ->
	Sum.

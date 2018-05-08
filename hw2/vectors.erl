-module(vectors).

-export([multVectors/2]).
-export([getMultMatrixElement/4]).

% Returns the element at (Row,Column) in the Matrix1*Matrix2 result matrix
getMultMatrixElement(From, Row,Column,Matrix1,Matrix2) ->
	Sum = multVectors(matrix:getRow(Matrix1, Row), matrix:getCol(Matrix2, Column)),
	From ! {Row, Column, Sum}.

% Multiplies two vectors
multVectors(ListVec1,ListVec2) when is_list(ListVec1) == true , is_list(ListVec2) == true , length(ListVec1) == length(ListVec2) ->
	multVectors(ListVec1,ListVec2,0).
multVectors([Head1|List1], [Head2|List2], Sum) ->
	multVectors(List1, List2, Sum + Head1*Head2);
multVectors([],[],Sum) ->
	Sum.

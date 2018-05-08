-module(matrix).
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
	_ = lists:append(Col, [Current_element]),
	mat_get_col2(Mat, Col_num, Col).
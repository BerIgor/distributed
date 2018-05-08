-module(matrix_server).
%-export([start_server/0]).
%-export([shut_down/0]).
-export([mult/2]).
%-export([get_version/0]).
%-export([explanation/0]).



mult(Mat1, Mat2) ->
	Mat1_C = tuple_size(Mat1),
	Mat2_R = tuple_size(element(1, Mat2)),
	io:format("~p,~p~n", [Mat1_R, Mat2_C]).
-module(test).

-compile(export_all).

start()->   
    loadBalance:startServers().

stop()->
    loadBalance:stopServers().

status()->
    io:format("Server 1 is handlling ~p tasks ~n ",[loadBalance:numberOfRunningFunctions(1)]),
    io:format("Server 2 is handlling ~p tasks ~n ",[loadBalance:numberOfRunningFunctions(2)]),
    io:format("Server 3 is handlling ~p tasks ~n ",[loadBalance:numberOfRunningFunctions(3)]).

whereare()->
    io:format("Server 1 pid is: ~p t~n ",[whereis(server1)]),
    io:format("Server 2 pid is: ~p t~n ",[whereis(server2)]),
    io:format("Server 3 pid is: ~p t~n ",[whereis(server3)]).

battle()->
    %compile:file(loadBalance),compile:file(sup),compile:file(servers), 
    F3 = fun()-> timer:sleep(3000),'f3finishh' end, 
    F5 = fun()-> timer:sleep(10000),'f5finishh' end, 

    %Divide 10 functions: 
    myLoop(F3,10),
    status(),
    myLoop(F5,100),
    status(),

    ok.
                
myLoop(_F,0)->
    ok;

myLoop(F,Times)->
    loadBalance:calcFun(self(),F,make_ref()),
    myLoop(F,Times-1).



main()->
    start(),
    battle(),
    %stop().
    ok_main.

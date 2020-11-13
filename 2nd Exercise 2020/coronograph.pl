:- dynamic (edge/2).
:- dynamic (countingpath/4).
:- dynamic (pathforcount/4).
:- dynamic connected/1.



readedges(Stream,M) :-              %rule that reads edges from in-stream 
    M > 1 ->
    read_line(Stream,[A,B]),
    nth0(0, [A,B],Start),
    nth0(1, [A,B],Dest),
    assert(edge(Start,Dest)),
    assert(edge(Dest,Start)),
    K is M - 1,
    readedges(Stream,K)
    ;   read_line(Stream,[A,B]) ,
        nth0(0, [A,B],Start),
        nth0(1, [A,B],Dest),
        assert(edge(Start,Dest)),
        assert(edge(Dest,Start)).


connected(Total) :-                         %check if graph is connected(if Total = N )
    findall(N, path(1,N,_),List1),
    sort(List1,List),
    length(List,Total).

restrictions(N,M,Bool):-                    %NO CORONA if N\==M or if Graph not connected
    N\==M -> Bool is 0 
    ;   \+connected(N) ->Bool is 0
    ;   Bool is 1 .

%rules that find cycle and put nodes of the cycle in a list

path(A,B,Path) :-                           %rule copyrights:https://www.cpp.edu/~jrfisher/www/prolog_tutorial/2_15.html?fbclid=IwAR1hOXMdokhjP53QDnTYKBYOvl20pBY0bGkV6Q3HIxtrP-0eqID4FJcLOF4
    travel(A,B,[A],Q,A), 
    reverse(Q,Path).

travel(A,B,L,L,J) :- 
    B\==J,
    edge(A,B).

travel(A,B,Visited,Path,J) :-
    edge(A,C),           
    C \== B,
    C \== J,
    \+member(C,Visited),
    travel(C,B,[C|Visited],Path,A).  

cycle(Cycle):-                              %rule that defines a cycle as a path from a node to itself
    once(path(X,X,Cycle)).

%rules that count and put in a list the nodes below a node that is in the cycle

pathforcount(Start,End,Cycle):-             %rule copyrights: https://stackoverflow.com/questions/10797793/how-to-visit-each-point-in-directed-graphw
    pathforcount(Start,End,[Start],Cycle).  

pathforcount(End,End,_,_).                  % rule for path that excludes all nodes that are in the cycle
pathforcount(Start,End,Parent,Cycle) :-     %,and the parent of each node
    edge(Start,Another),
    \+memberchk(Another,Parent),
    \+memberchk(Another,Cycle),
    pathforcount(Another,End,[Another|Parent],Cycle).
    

countingpath(Start,Dest,Cycle,Result):-     
    findall(Dest,pathforcount(Start,Dest,Cycle),List),
    length(List,Result).

countbelow([],_,Countlist,Results):-msort(Countlist,Results). %sorting when we end the procedure 
countbelow([CH|CT],Cycle,Countlist,Results):-                 %for each node of the cycle,count the nodes below 
    countingpath(CH,_,Cycle,Result),
    NewCountlist = [Result|Countlist],
    countbelow(CT,Cycle,NewCountlist,Results).



solution(MyAnswer,N,M) :-                   %check if restrictions are met then
    restrictions(N,M,Bool),                 %find cycle and count nodes below each cycle node
    Bool =:= 0 ->                           %and give the appropriate output
    MyAnswer = ["'NO CORONA'"],
    retractall(edge(_1,__3))
    ;   cycle(Cycle),
        countbelow(Cycle,Cycle,[],Results),
        length(Results,L),
        MyAnswer = [[L,Results]],
        retractall(edge(_1,__3)),
        retractall(Results).

read_line(Stream, L) :-                     %the following rule is given by the professors of the course 
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

readNandM(Stream,N,M) :-                    %rule that reads N and M from file
    read_line(Stream,[A,B]) ,
    nth0(0, [A,B], N),
    nth0(1, [A,B], M).

dographs(T,Answers,Stream,WholeList) :-     %our main
    T > 0 ->
    readNandM(Stream,N,M),
    readedges(Stream,M),
    solution(MyAnswer,N,M),
    append(WholeList,MyAnswer,NewWholeList),
    J is T - 1,
    dographs(J,Answers,Stream,NewWholeList)
    ;   Answers = WholeList.

coronograph(File,Answers) :-                %final rule 
    open(File,read,Stream),
    read_line(Stream,T),
    dographs(T,Answers,Stream,[]),
    !,
    close(Stream).
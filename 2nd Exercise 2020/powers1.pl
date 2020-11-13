decimaltobinary(0,[0]). %https://stackoverflow.com/questions/20437673/prolog-putting-elements-in-a-list-for-a-decimal-to-binary-conversion
decimaltobinary(1,[1]).
decimaltobinary(N,List):-
    N > 1,
    A is N mod 2,
    B is N // 2,
    decimaltobinary(B,L1),
    List=[A|L1].


%sumlist([Element],Element).         %rule that calculates the sum of the list 
%sumlist([H1,H2|T],Sum):-
 %   sumlist([H1+H2|T],Sum).

restrictions(N,K,Flag) :-           %rule that checks if two restrictions are met
                                    %Flag = 1->accepted else denied 
    K > N ->                        %if K>N impossible 
    Flag is 0
    ; 
    decimaltobinary(N,List),
    sum_list(List,Sum),
    K < Sum ->                      %and also if K < Minimal powers of 2 needed
    Flag is 0 
    ;
    Flag is 1 .


listseparate([X|Xs],X,Xs).          %rule that separates Head from Tail


plustimes([X|Xs],List1,List2) :-    %rule that alters the list formed in the first rule 
    listseparate([X|Xs], A , [Y|Ys]),
    Y =\= 0 ->
    Newhead is Y - 1,
    B is A + 2,
    gettherestback(List2,B,List3),
    append(List3,[Newhead|Ys],List1)
    ;   gettherestback(List2,X,List3),
        plustimes(Xs,List1,List3).


gettherestback([],X,[X]).          
gettherestback([H|T],X,[H|T2]):-
    gettherestback(T,X,T2).
    

cut_last(L1, L2):-              %delete the last element of a list
    append(L2, [_], L1).


zerosout(List,No0List) :-
    last(List,0) ->
    cut_last(List,NewList),
    zerosout(NewList,No0List)
    ;   No0List = List.


theanswer(List,K,MyAnswer) :-
    sum_list(List,Sum),
    Sum < K -> 
    plustimes(List,NewList,[]),
    theanswer(NewList,K,MyAnswer)
    ; MyAnswer = List .


solution(MyAnswer , N, K) :-
    restrictions(N,K,Flag), 
    Flag =:= 0 -> MyAnswer = []         %if our restrictions are not met
    ;   decimaltobinary(N,List),
        theanswer(List,K,MyAnswer) .


read_line(Stream, L) :-                 %the following function is given by the professors of the course 
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).


readNandK(Stream,N,K) :-
    read_line(Stream, [A,B]) ,
    nth0(0, [A,B], N),
    nth0(1, [A,B], K).


readInts(T , Answers, Stream, WholeList) :-
    T > 0 ->                                    %while T > 0 run 
    readNandK(Stream,N,K),
    solution(MyAnswer,N,K),
    zerosout(MyAnswer,MyNewAnswer),
    append(WholeList,[MyNewAnswer],NewWholeList),
    J is T - 1,
    readInts(J, Answers, Stream, NewWholeList)
    ;   Answers = WholeList.


powers2(File, Answers) :-
    open(File, read, Stream),
    read_line(Stream, T),
    readInts(T , Answers, Stream , []),
    close(Stream).
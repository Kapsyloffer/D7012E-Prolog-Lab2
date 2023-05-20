nsertionSort([], []).
insertionSort([(Sum, I, J, Set)|Xs], Res):-
    iSort(Xs, Res2),
    insert((Sum, I, J, Set), Res2, Res).

%return empty list on basecase-
insert([], _, []).

%
insert(
    (Sum, I, J, Set), 
    [], 
    [(Sum, I, J, Set)]
).

%
insert(
    (Sum, I, J, Set), 
    [(Sum2, I2, J2, Set2)|List], 
    [(Sum, I, J, Set), (Sum2, I2, J2, Set2)|List]):-
        Sum =< Sum2.

%
insert(
    (Sum, I, J, Set), 
    [(Sum2, I2, J2, Set2)|List], 
    [(Sum2, I2, J2, Set2)|Result]):-
        Sum > Sum2,
        insert((Sum, I, J, Set), List, Result).



smallestKset(_, 0, _) :-
    write('There are no sets to pick. :/'), !.
    
smallestKset([], _, _) :-
    write('Empty.'), !.

smallestKset(List, K, Output) :-
    kSmallest(List, K, Output),
    write('Sum\ti\tj\tSublist\n'),
    stringOutput(Output).

writeKSmallest([(Sum, I, J, List)| Rest]):-
    write((Sum, "\t", I, "\t", J, "\t", List)),
   writeKSmallest(Rest).


kSmallest([], _, []).
kSmallest(List, K, Subs):-
    %todo




%Generera listan från test_1
list_test1(List) :-
    numlist(1, 100, Range),
    maplist(gen_list_test1, Range, List).
gen_list_test1(X, Res) :-
    Res is X * (-1) ^ X.

%Lista 2
list_test2([24,-11,-34,42,-24,7,-19,21]).
%Lista 3
list_test3([3,2,-4,3,2,-5,-2,2,3,-3,2,-5,6,-2,2,3]).

main :-
    % Test case 1, k = 15
    list_test1(List_test1),
    smallestKset(List_test1, 15),

    % Test case 2, k = 6
    list_test2(List_test2),
    smallestKset(List_test2, 6),

    % Test case 3, k = 8
    list_test3(List_test3).   
    smallestKset(List_test3, 8),
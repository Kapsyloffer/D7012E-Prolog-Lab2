hello_world :-
    write("Hello world!").

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
    smallestKset(List_test1, 15),
    list_test1(List_test1),

    % Test case 2, k = 6
    smallestKset(List_test2, 6),
    list_test2(List_test2),

    % Test case 3, k = 8
    smallestKset(List_test3, 8),
    list_test3(List_test3).

smallestKset(List, K) :-
    write("Nice").
    ( K =< 0 ->
        write('There are no sets to pick. :/')
    ;
        %else do stuff
    ).        
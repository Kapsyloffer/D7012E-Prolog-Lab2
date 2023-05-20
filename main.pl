%-- Genererar alla möjliga subsets av en lista
subSets([], _, []).
subSets(List, Index, SubsetList):-
    sumSubsets(List, Sum),
    length(List, Len),      %Basically size()
    I = Index,              %Set I to index (GetIndex är gone!!)
    J = Index + Len - 1,    %Set J to ...that.
    SubsetTuple = (Sum, I, J, List), 
    removeFirstElement(List, NewList),
    subSets(NewList, I, RemainingSubsets),
    append([SubsetTuple], RemainingSubsets, SubsetList).

%Nukar första elementet i en lista
removeFirstElement([], []). 
removeFirstElement([_|Tail], Tail).

%-- Räknar ihop summan av ett givet subset, t.ex. [1, 2] ger 3
sumSubsets([], 0).
sumSubsets([X|Xs], Sum):-
    sumSubsets(Xs, NewSum),
    Sum is X + NewSum.


% Få alla possible sublists.
generateAllSublists([], _, []).
generateAllSublists([First | Rest], StartIndex, Sublists) :-
    subSets([First | Rest], StartIndex, SublistsAtStart),
    NextIndex is StartIndex + 1,
    generateAllSublists(Rest, NextIndex, SublistsAfterRest),
    append(SublistsAtStart, SublistsAfterRest, Sublists).



%-- Sorterar subset efter storlek, t.ex. [-99] hamnar före [-98]
insertionSort([], []).
insertionSort([X|Xs], SortedList) :-
    insertionSort(Xs, RemainingSortedList),
    insert(X, RemainingSortedList, SortedList).

%Case 0: return empty list on basecase-
insert([X], _, [X]).

%Case 1: Not empty, sum <= sum2
insert(X, [Y|Ys], [X,Y|Ys]) :-
    X = (Sum, _, _, _),
    Y = (Sum2, _, _, _),
    Sum =< Sum2.


%Case 2: Not empty, sum >= sum2
insert(X, [Y|Ys], [Y|Result]) :-
    X = (Sum, _, _, _),
    Y = (Sum2, _, _, _),
    Sum > Sum2,
    insert(X, Ys, Result).


%Samma som förra labben.
smallestKset(_, 0, _) :-
    write('There are no sets to pick. :/'), !.
    
smallestKset([], _, _) :-
    write('Empty.'), !.

smallestKset(List, K, Output) :-
    kSmallest(List, K, Output),
    write('Sum\ti\tj\tSublist\nk='),
    write(K), nl,
    writeKSmallest(Output).




kSmallest([], _, []).
kSmallest(List, K, Sublists):-
    generateAllSublists(List, 0, AllSubsets),
    insertionSort(AllSubsets, Sorted),
    take(K, Sorted, Sublists).


% Basically take from Haskell
take(0, _, []).
take(_, [], []).
take(K, [X|Xs], [X|Ys]) :-
    K > 0,
    K1 is K - 1,
    take(K1, Xs, Ys).


    writeKSmallest([(Sum, I, J, List) | _]) :- 
        write(Sum), 
        write('\t'),
        write(I), 
        write('\t'),
        write(J), 
        write('\t'),
        write(List), nl.
    writeKSmallest([_ | Rest]) :-
        writeKSmallest(Rest).



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
    smallestKset(List_test1, 15, Output1),

    % Test case 2, k = 6
    list_test2(List_test2),
    smallestKset(List_test2, 6, Output2),

    % Test case 3, k = 8
    list_test3(List_test3),
    smallestKset(List_test3, 8, Output3).
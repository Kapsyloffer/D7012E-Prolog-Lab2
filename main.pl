% Drop N elements from head
dropNFromHead(_, [], []). %Base case
dropNFromHead(0, L, L). %0
dropNFromHead(K, [_|Tail], Result) :- %All else
    K > 0, 
    K2 is K - 1, 
    dropNFromHead(K2, Tail, Result).

%Gets the first element in a list.
getFirst([], []).
getFirst([Head|_], Head).

getAllLists(1, Input, [Last]) :-
    member(Last, Input).
getAllLists(N, Input, [First, Second|Perm]) :- 
    N > 1, N0 is N-1, 
    member(First, Input), 
    getAllLists(N0, Input, [Second|Perm]).

processSublistIndices(_, [], Temp, Temp).
processSublistIndices(List, [Head|Tail], Temp, Result) :-
    calcSublist(Head, List, Calc), 
    append(Temp, [Calc], AccumulatedList), 
    processSublistIndices(List, Tail, AccumulatedList, Result).

calcSublist([Start|End], List, Result) :-
    getFirst(End, EndFirst),
    StartMinusOne is Start - 1,
    EndAdjusted is EndFirst - StartMinusOne,
    dropNFromHead(StartMinusOne, List, DroppedList),
    take(EndAdjusted, DroppedList, Sublist),
    sumlist(Sublist, Sum),
    Result = [Sum, Start, EndFirst, Sublist].


%-- Sorterar subset efter storlek, t.ex. [-99] hamnar före [-98]
insertionSort(List, Sorted) :-
    insertionSort(List, [], Sorted).

insertionSort([], Acc, Acc).
insertionSort([X|Xs], Acc, Sorted) :-
    insert(X, Acc, NewAcc), 
    insertionSort(Xs, NewAcc, Sorted).

%Helper functions for insertionsort
insert(X, [], [X]).
insert(X, [Y|Ys], [X, Y|Ys]) :-
    X @< Y.
insert(X, [Y|Ys], [Y|Zs]) :-
    X @>= Y, 
    insert(X, Ys, Zs).

getAllSublists(List, Result) :-
    indexList(List, IndexList), 
    processSublistIndices(List, IndexList, [], Temp), 
    sort(Temp, Result).

indexList(List, Result) :-
    length(List, Length), 
    findall(Index, between(1, Length, Index), IndexList), 
    findall(Perm, (getAllLists(2, IndexList, Permutation), insertionSort(Permutation, Perm)), Permutations), 
    sort(Permutations, Result).

kSmallest(List, K) :-
    getAllSublists(List, Sublists), 
    take(K, Sublists, Result), 
    write("kSmallest K="), write(K), nl, 
    writeSmallestK(Result), !.
    
writeSmallestK([]).
writeSmallestK([[Sum, I, J, Sublist]|Rest]) :-
    format("Sum: ~w, I: ~w, J: ~w, \tSublist: ~w", [Sum, I, J, Sublist]), nl, 
    writeSmallestK(Rest).

% Basically take from Haskell
take(0, _, []).
take(_, [], []).
take(K, [X|Xs], [X|Ys]) :-
    K > 0, 
    K1 is K - 1, 
    take(K1, Xs, Ys).


% Generate the list for test_1
list_test1(List) :-
    numlist(1, 99, Range), 
    maplist(gen_list_test1, Range, List).
gen_list_test1(X, Res) :-
    Res is X * (-1) ^ X.

% Test case 2
list_test2([24, -11, -34, 42, -24, 7, -19, 21]).
% Test case 3
list_test3([3, 2, -4, 3, 2, -5, -2, 2, 3, -3, 2, -5, 6, -2, 2, 3]).

% Test case 1, k = 15
test1:-
    list_test1(List_test1), 
    kSmallest(List_test1, 15).

% Test case 2, k = 6
test2:-
    list_test2(List_test2), 
    kSmallest(List_test2, 6).

% Test case 3, k = 8
test3:-
    list_test3(List_test3), 
    kSmallest(List_test3, 8).

test:-
    test1, nl, 
    test2, nl, 
    test3.
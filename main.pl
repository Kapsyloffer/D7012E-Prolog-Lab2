%--Christoffer Lindkvist

%Gets the first element in a list.
getFirst([], []).
getFirst([Head|_], Head).

%Genererar alla kombinationer av sublists av längd N, och returnar [First, Second|Perm]
%-- Generererar x sublists av längd n, t.ex.
%-- subListsWithLength 3 [1,2,3,4,5] ger oss: [[1,2,3],[2,3,4],[3,4,5]]
subListsWithLength(1, Input, [Last]) :-
    member(Last, Input).
subListsWithLength(N, Input, [First, Second|Perm]) :- 
    N > 1, 
    N1 is N-1, 
    member(First, Input), 
    subListsWithLength(N1, Input, [Second|Perm]).

%-- Genererar alla möjliga subsets av en lista
subSets(List, Result) :-
    length(List, Length), 
    findall(Index, between(1, Length, Index), IList), 
    findall(Perm, (subListsWithLength(2, IList, Permutation), insertionSort(Permutation, Perm)), Permutations), 
    sort(Permutations, IndexList), %stackoverflow på InsertionSort :/
    sumSubsets(List, IndexList, [], Temp), 
    insertionSort(Temp, Result).

%-- Räknar ihop summan av ett givet subset, t.ex. [1, 2] ger 3
sumSubsets(_, [], Temp, Temp).
sumSubsets(List, [Head|Tail], Temp, Result) :-
    calcSublist(Head, List, Calc), 
    append(Temp, [Calc], AccumulatedList), 
    sumSubsets(List, Tail, AccumulatedList, Result).


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

% Fixar sum, i, j, och minsta sublisten.
calcSublist([I|Tail], List, Result) :-
    getFirst(Tail, J),  %Få J värdet ur tailen
    N is I - 1,         %Startindex
    N2 is J - N,        %Slutindex
    dropNFromHead(N, List, XS),
    take(N2, XS, Sublist),
    sumlist(Sublist, Sum),
    Result = [Sum, I, J, Sublist].

% Drop N elements from head
dropNFromHead(_, [], []). %Base case
dropNFromHead(0, L, L). %0
dropNFromHead(K, [_|Tail], Result) :- %All else
    K > 0, 
    K2 is K - 1, 
    dropNFromHead(K2, Tail, Result).

% Basically take from Haskell
take(0, _, []).
take(1, [X], [Y]):- %Annars printar den 1 för mycket.
    getFirst([X], [Y]). 
take(_, [], []).
take(K, [X|Xs], [X|Ys]) :-
    K > 0, 
    K1 is K - 1, 
    take(K1, Xs, Ys).

%ksmallest
kSmallest(List, K) :-
    subSets(List, Sublists), 
    take(K, Sublists, Result), 
    write("kSmallest K="), write(K), nl, 
    writeSmallestK(Result), !.

%Printa allt
writeSmallestK([]).
writeSmallestK([[Sum, I, J, Sublist]|Rest]) :-
    format("Sum: ~w, I: ~w, J: ~w, \tSublist: ~w", [Sum, I, J, Sublist]), nl, 
    writeSmallestK(Rest).

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

%test all
test:-
    test1, nl, 
    test2, nl, 
    test3.
/* Bagian I */

/* Deklarasi Fakta */

pria(athif).
pria(dillon).
pria(henri).
pria(michael).
pria(hanif).
pria(robert).
pria(bagas).
pria(fio).
pria(daniel).
pria(rupert).

wanita(joli).
wanita(elysia).
wanita(margot).
wanita(jena).
wanita(jeni).
wanita(ana).
wanita(emma).

usia(athif, 60).
usia(joli, 58).
usia(dillon, 63).
usia(elysia, 500).
usia(henri, 48).
usia(margot, 43).
usia(michael, 28).
usia(hanif, 47).
usia(robert, 32).
usia(bagas, 29).
usia(jena, 27).
usia(fio, 30).
usia(jeni, 28).
usia(ana, 23).
usia(daniel, 7).
usia(rupert, 6).
usia(emma, 6).

menikah(athif, joli).
menikah(joli, athif).
menikah(dillon, elysia).
menikah(elysia, dillon).
menikah(henri, margot).
menikah(margot, henri).
menikah(jena, fio).
menikah(fio, jena).
menikah(fio, jeni).
menikah(jeni, fio).

anak(margot, athif).
anak(margot, joli).
anak(michael, athif).
anak(michael, joli).
anak(hanif, dillon).
anak(hanif, elysia).
anak(robert, henri).
anak(robert, margot).
anak(bagas, henri).
anak(bagas, margot).
anak(jena, henri).
anak(jena, margot).
anak(jeni, hanif).
anak(ana, hanif).
anak(daniel, jena).
anak(daniel, fio).
anak(rupert, jena).
anak(rupert, fio).
anak(emma, fio).
anak(emma, jeni).

/* Deklarasi Rules */

/* saudara(X,Y): X adalah saudara kandung maupun tiri dari Y */
saudara(X, Y) :- anak(X, Z), anak(Y, Z), X \== Y.

/* saudaratiri(X,Y): X adalah saudara tiri dari Y */
saudaratiri(X, Y) :-
    saudara(X, Y),
    (anak(X, A), anak(Y, B), pria(A), pria(B), A \== B;
     anak(X, A), anak(Y, B), wanita(A), wanita(B), A \== B).

/* kakak(X,Y): X adalah kakak dari Y (kakak kandung maupun tiri) */
kakak(X, Y) :- saudara(X, Y), usia(X, A), usia(Y, B), A > B.

/* keponakan(X,Y): X adalah keponakan dari Y */
keponakan(X, Y) :- anak(X, A), saudara(A, Y).

/* mertua(X,Y): X adalah mertua dari Y */
mertua(X, Y) :- anak(A, X), menikah(A, Y).

/* nenek(X,Y): X adalah nenek dari Y */
nenek(X, Y) :- anak(A, X), anak(Y, A), wanita(X).

/* keturunan(X,Y): X adalah keturunan dari Y (anak, cucu, dan seterusnya) */
keturunan(X, Y) :- anak(X, Y).
keturunan(X, Y) :- anak(X, A), keturunan(A, Y).

/* lajang(X): X adalah orang yang tidak menikah */
lajang(X) :- (pria(X); wanita(X)), \+ menikah(X, _).

/* anakbungsu(X): X adalah anak paling muda */
anakbungsu(X) :- anak(X, _), \+ kakak(X, _).

/* yatimpiatu(X): X adalah orang yang orang tuanya tidak terdefinisi */
yatimpiatu(X) :- (pria(X); wanita(X)), \+ anak(X, _).


/* Bagian II */

/* Deklarasi Fakta */

/* Deklarasi Rules */

/* exponent(A, B, X) */
exponent(_, 0, 1) :- !.
exponent(A, B, X) :- B1 is B - 1, exponent(A, B1, X2), X is A * X2.

/* population(P, R, T, C, X) */
population(P, _, 0, _, P) :- !.
population(P, R, T, C, X) :-
    T mod 2 =\= 0,
    TPrev is T - 1,
    CNow is C + T,
    population(P, R, TPrev, C, XPrev),
    X is XPrev * R + CNow,
    !.
population(P, R, T, C, X) :-
    T mod 2 =:= 0,
    TPrev is T - 1,
    CNow is C + T,
    population(P, R, TPrev, C, XPrev),
    X is XPrev * R - CNow.

/* perrin(N, X) */
perrin(0, 3) :- !.
perrin(1, 0) :- !.
perrin(2, 2) :- !.
perrin(N, X) :-
    N2 is N - 2,
    N3 is N - 3,
    perrin(N2, X2),
    perrin(N3, X3),
    X is X2 + X3.

/* hcf(A, B, X) */
hcf(0, 0, _) :- !, fail.
hcf(A, 0, A) :- A > 0, !.
hcf(A, 0, X) :- A < 0, X is -A, !.
hcf(A, B, X) :- B < 0, C is -B, hcf(A, C, X), !.
hcf(A, B, X) :- A < 0, C is -A, hcf(C, B, X), !.
hcf(A, B, X) :- C is A mod B, hcf(B, C, X).

/* makePattern(N) */
makePattern(N) :- N < 1, !, fail.
makePattern(N) :- writeColumn(N, 0, 0).

/* Rules tambahan */

elementNumber(PatternSize, IndexRow, IndexColumn, Number) :-
    IndexRow2 is PatternSize - 1 - IndexRow,
    IndexColumn2 is PatternSize - 1 - IndexColumn,
    min([IndexRow, IndexRow2], MinIndexRow),
    min([IndexColumn, IndexColumn2], MinIndexColumn),
    min([MinIndexRow, MinIndexColumn], Number).

writeColumn(PatternSize, IndexRow, IndexColumn) :- 
    IndexRow =:= PatternSize - 1,
    IndexColumn =:= PatternSize - 1,
    elementNumber(PatternSize, IndexRow, IndexColumn, Number),
    write(Number),
    nl,
    !.
writeColumn(PatternSize, IndexRow, IndexColumn) :-
    IndexColumn =:= PatternSize - 1,
    elementNumber(PatternSize, IndexRow, IndexColumn, Number),
    write(Number),
    nl,
    NextRow is IndexRow + 1,
    writeColumn(PatternSize, NextRow, 0),
    !.
writeColumn(PatternSize, IndexRow, IndexColumn) :-
    elementNumber(PatternSize, IndexRow, IndexColumn, Number),
    write(Number),
    NextColumn is IndexColumn + 1,
    writeColumn(PatternSize, IndexRow, NextColumn).


/* Bagian III */

/* Deklarasi Fakta */

/* Deklarasi Rules */

/* min(List,  Min) */
min([Head | []], Head) :- !.
min([Head | Tail], Head) :- min(Tail, MinTail), Head < MinTail, !.
min([_ | Tail], MinTail) :- min(Tail, MinTail).

/* max(List,  Max) */
max([Head | []], Head) :- !.
max([Head | Tail], Head) :- max(Tail, MaxTail), Head > MaxTail, !.
max([_ | Tail], MaxTail) :- max(Tail, MaxTail).

/* range(List,  Range) */
range(List, Range) :- min(List, Min), max(List, Max), Range is Max - Min.

/* count(List,  Count) */
count([], 0) :- !.
count([_ | Tail], Count) :- count(Tail, CountTail), Count is 1 + CountTail.

/* sum(List,  Sum) */
sum([Head | []], Head) :- !.
sum([Head | Tail], Sum) :- sum(Tail, SumTail), Sum is Head + SumTail.

/* getIndex(List, SearchedElement, Result) */
getIndex([Head | _], SearchedElement, 1) :- SearchedElement =:= Head, !.
getIndex([_ | Tail], SearchedElement, Result) :-
    getIndex(Tail, SearchedElement, ResultTail),
    Result is 1 + ResultTail.

/* getElement(List, Index, Result) */
getElement([Head | _], 1, Head) :- !.
getElement([_ | Tail], Index, Result) :-
    Index > 1,
    Index2 is Index - 1,
    getElement(Tail, Index2, Result).

/* swap(List, Index1, Index2, Result) */
swap(List, Index1, Index2, Result) :-
    getElement(List, Index1, Element1),
    getElement(List, Index2, Element2),
    setElement(List, Index1, Element2, Result1),
    setElement(Result1, Index2, Element1, Result).

/* slice(List, Start, End, Result) */
slice([], _, _, []) :- !.
slice(_, 1, End, []) :- End =< 1, !.
slice([Head | Tail], 1, End, Result) :-
    End2 is End - 1,
    slice(Tail, 1, End2, Result2),
    Result = [Head | Result2],
    !.
slice([_ | Tail], Start, End, Result) :-
    Start2 is Start - 1,
    End2 is End - 1,
    slice(Tail, Start2, End2, Result).

/* sortList(List, Result) */
sortList([], []) :- !.
sortList(List, Result) :-
    min(List, Min),
    getIndex(List, Min, IndexMin),
    swap(List, 1, IndexMin, [_ | Tail]),
    sortList(Tail, SortedTail),
    Result = [Min | SortedTail].

/* Rules tambahan */

setElement([_ | Tail], 1, Value, [Value | Tail]) :- !.
setElement([Head | Tail], Index, Value, [Head | Result2]) :-
    Index > 1,
    Index2 is Index - 1,
    setElement(Tail, Index2, Value, Result2).

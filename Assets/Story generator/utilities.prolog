ensure(P) :-
   clause(P, _), !.
ensure(P) :-
   assert(P).

%% semieven_split(+Number, -Number1, -Number2) is det
%  Randomly chooses positive integers that sum to a specified integer greater than 2.
semieven_split(Sum, Number1, Number2) :-
   Number1 is random_integer(Sum//3, (2*Sum)//3),
   Number2 is Sum-Number1.

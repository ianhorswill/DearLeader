:- higher_order(constraint(1)).
constraint( (A \= B) ) :-
   !,
   dif(A, B).
constraint( (A = B) ) :-
   !,
   A = B.
constraint((P, Q)) :-
   !,
   constraint(P),
   constraint(Q).
constraint(DifCall) :-
   functor(DifCall, dif, _),
   !,
   DifCall.
constraint(T) :-
   T,
   add_to_setup(T).

add_to_setup(T) :-
   memberchk(T, $story_setup),
   !.
add_to_setup(T) :-
   extend_setup($story_setup, T, NewSetup),
   bind(story_setup, NewSetup).

extend_setup(Setup, Fact, Setup) :-
   memberchk(Fact, Setup),
   !.
extend_setup(Setup, Fact, NewSetup) :-
   \+ contradicts_setup(Fact, Setup),
   all(Implication, implies(Fact, Implication), Implications),
   extend_setup_with_list([Fact | Setup], Implications, NewSetup).

contradicts_setup(Fact, S) :-
   contradiction(Fact, Contradictor),
   memberchk(Contradictor, S).
contradicts_setup(Fact, S) :-
   contradiction(Contradictor, Fact),
   memberchk(Contradictor, S).

extend_setup_with_list(Setup, [], Setup).
extend_setup_with_list(Setup, [Fact | Rest], NewSetup) :-
   extend_setup(Setup, Fact, I),
   extend_setup_with_list(I, Rest, NewSetup).

:- higher_order(contradiction(1,1)).
contradiction(P, ~P).

:- external (~)/1.
:- higher_order(~1).

:- external symmetric/2, generalization/1.

true_in_state((P, Q), State) :-
   !,
   true_in_state(P, State),
   true_in_state(Q, State).
true_in_state((P ; Q), State) :-
   !,
   (true_in_state(P, State) ; true_in_state(Q, State)).
true_in_state(P, State) :-
   specialization(P, Q),
   true_in_state_aux(Q, State).

true_in_state_aux(P, State) :-
   memberchk(P, State).
true_in_state_aux(P, State) :-
   symmetric(P, Q),
   memberchk(Q, State).

specialization(Prop, Prop).
specialization(Prop, Spec) :-
   generalization(S, Prop),
   specialization(S, Spec).

:- public update_state/4.

%% update_state(+State, +Add, +Delete, -NewState)
%  NewState is State Delete removed and Add added.
update_state(State, Add, Delete, NewState) :-
   remove_all(State, Delete, TState),
   add_all(TState, Add, NewState),
   !.

%% remove_all(+State, +FactList, -NewState)
%  NewState is State with FactList removed.
remove_all(State, [], State).
remove_all(State, [Fact | Rest], NewState) :-
   delete(State, Fact, TState),
   (symmetric(Fact, Sym) -> delete(TState, Sym, T2) ; T2=TState),
   remove_all(T2, Rest, NewState).

%% add_all(+State, +FactList, -NewState)
%  NewState is State with FactList added to it.
add_all(State, [], State).
add_all(State, [Fact | Rest], NewState) :-
   ground(Fact),
   memberchk(Fact, State) ->
   add_all(State, Rest, NewState)
   ;
   add_all([Fact | State], Rest, NewState).
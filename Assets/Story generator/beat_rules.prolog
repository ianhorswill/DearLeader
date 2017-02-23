%%%
%%% BEATS
%%%

goal_expansion(beat(BeatWithConstraints : { Options }, Text),
	       (Head :- Simplified)) :-
   !,
   extract_domain_constraints(BeatWithConstraints, Beat, Constraints),
   add_arguments(Beat,
		 [Plan, [Beat | IPlan], InState, OutState],
		 Head),
   compile_beat_body(Beat, Options, Body, Plan, IPlan, InState, OutState),
   simplify_conjunction((constraint(Constraints), Body), Simplified),
   compile_surface_form(Beat, Text).

goal_expansion(beat(BeatWithConstraints, Text),
	       (Head :- Simplified)) :-
   extract_domain_constraints(BeatWithConstraints, Beat, Constraints),
   add_arguments(Beat,
		 [Plan, [Beat | Plan], InState, InState],
		 Head),
   simplify_conjunction(constraint(Constraints), Simplified),
   compile_surface_form(Beat, Text).

compile_beat_body(Beat, (Option1, Option2), (Body1, Body2), Plan, NewPlan, InState, OutState) :-
   !,
   compile_beat_body(Beat, Option1, Body1, Plan, IPlan, InState, TState),
   compile_beat_body(Beat, Option2, Body2, IPlan, NewPlan, TState, OutState).

compile_beat_body(_, constraint: T, constraint(T), Plan, Plan, InState, InState).
compile_beat_body(_, precondition: Pre, true_in_state(Pre, InState),
		  Plan, Plan, InState, InState).
compile_beat_body(Beat, add: List, add_all(InState, List, OutState), Plan, Plan, InState, OutState) :-
   list(List),
   forall(member(Proposition, List),
	  assert(adds(Beat, Proposition))).

compile_beat_body(Beat, add: Proposition, add_all(InState, [Proposition], OutState), Plan, Plan, InState, OutState) :-
   \+ list(Proposition),
   assert(adds(Beat, Proposition)).

compile_beat_body(_, delete: List, remove_all(InState, List, OutState), Plan, Plan, InState, OutState) :-
   list(List).
compile_beat_body(_, delete: Prop, remove_all(InState, [Prop], OutState), Plan, Plan, InState, OutState) :-
   \+ list(Prop).

compile_beat_body(_, preestablish: Prop, establish(Prop, Plan, NewPlan, State, NewState), Plan, NewPlan, State, NewState).

:- external setting/1.
compile_beat_body(_, setting: S, establish(setting(S), Plan, NewPlan, State, NewState), Plan, NewPlan, State, NewState) :-
   ensure(setting(S)).

compile_beat_body(Head, text: String, true, Plan, Plan, State, State) :-
   !,
   compile_surface_form(Head, String).

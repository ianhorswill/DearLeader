%%%
%%% PLOT RULES
%%%

goal_expansion((TaskWithConstraints : MoreConstraints ==> Method),
	       (Head :- Simplified)) :-
   find_user_options(MoreConstraints),
   extract_domain_constraints(TaskWithConstraints, Task, Constraints),
   add_arguments(Task, [InPlan, OutPlan, InState, OutState], Head),
   expand_body(Method, Body, InPlan, OutPlan, InState, OutState),
   simplify_conjunction( (constraint((Constraints, MoreConstraints)),
			  Body ),
			Simplified).
goal_expansion((TaskWithConstraints ==> Method),
	       (Head :- Simplified)) :-
   extract_domain_constraints(TaskWithConstraints, Task, Constraints),
   add_arguments(Task, [InPlan, OutPlan, InState, OutState], Head),
   expand_body(Method, Body, InPlan, OutPlan, InState, OutState),
   simplify_conjunction((constraint(Constraints), Body), Simplified).

expand_body(Trope, Compiled, InPlan, OutPlan, InState, OutState) :-
   var(Trope),
   !,
   expand_body(do(Trope), Compiled, InPlan, OutPlan, InState, OutState).
expand_body((T1, T2), (P1, P2), InPlan, OutPlan, InState, OutState) :-
   !,
   expand_body(T1, P1, InPlan, TPlan, InState, TState),
   expand_body(T2, P2, TPlan, OutPlan, TState, OutState).
expand_body({ Code }, Code, Plan, Plan, State, State).

expand_body(Task, Predicate, InPlan, OutPlan, InState, OutState) :-
   add_arguments(Task, [InPlan, OutPlan, InState, OutState], Predicate).

:- external theme/1, genre/1.

find_user_options((A,B)) :-
   !,
   find_user_options(A),
   find_user_options(B).
find_user_options(theme(X)) :-
   ensure(theme(X)).
find_user_options(genre(X)) :-
   ensure(genre(X)).
find_user_options(_) :- !.
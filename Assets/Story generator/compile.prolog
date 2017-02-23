:- op(1200, xfx, '==>').
:- public ('==>')/2, beat/2.
:- public compile_htn_rules/0.
:- indexical(story_setup=[]).
:- external contradiction/2.

%%%
%%% Front end
%%%

compile_htn_rules :-
   compile_htn((_Task ==> _Method)),
   compile_htn(beat(_Declaration, _Text)).

compile_htn(Pattern) :-
   forall(clause(Pattern, Body),
	  compile_htn_declaration(Pattern, Body)).
compile_htn_declaration(Pattern, _Body) :-
   goal_expansion(Pattern, Expansion),
   ensure_randomizable(Expansion),
   assertz(Expansion),
   !.
ensure_randomizable((H :- _)) :-
   functor(H, F, A),
   randomizable(F/A).

compile_htn_declaration(Head, _Body) :-
   log(unable_to_expand:Head).

%%%
%%% Arglist parsing
%%%

extract_domain_constraints(With, Without, Constraints) :-
   With =.. [Functor | ArglistWith],
   compile_domain_constraints(ArglistWith, ArglistWithout, Constraints),
   Without =.. [Functor | ArglistWithout].

compile_domain_constraints([], [], true).
compile_domain_constraints([Var | RestWith], [Var | RestWithout], RestCompiled) :-
   var(Var),
   !,
   compile_domain_constraints(RestWith, RestWithout, RestCompiled).
compile_domain_constraints([Var:Constraint | RestWith], [Var | RestWithout], (Compiled, RestCompiled)) :-
   !,
   add_arguments(Constraint, [Var], Compiled),
   compile_domain_constraints(RestWith, RestWithout, RestCompiled).
compile_domain_constraints([Var | RestWith], [Var | RestWithout], RestCompiled) :-
   compile_domain_constraints(RestWith, RestWithout, RestCompiled).

%%%
%%% Utilities
%%%

add_arguments(In, Arguments, Out) :-
   In =.. List,
   append(List, Arguments, BigList),
   Out =.. BigList.

simplify_conjunction((true, Exp), Opt) :-
   !,
   simplify_conjunction(Exp, Opt).
simplify_conjunction((Exp, true), Opt) :-
   !,
   simplify_conjunction(Exp, Opt).
simplify_conjunction((A, B), Simplified) :-
   simplify_conjunction(A, ASimp),
   simplify_conjunction(B, BSimp),
   simplify_conjunction_aux(ASimp, BSimp, Simplified),
   !.
simplify_conjunction(constraint(P), Simplified) :-
   simplify_conjunction(P, PSimp),
   (PSimp == true -> Simplified=true ; Simplified=constraint(PSimp)).
simplify_conjunction(Exp, Exp).

simplify_conjunction_aux(true, true, true).
simplify_conjunction_aux(true, P, P).
simplify_conjunction_aux(P, true, P).
simplify_conjunction_aux(P, Q, (P, Q)).


:- public establish/5, when/6, unless/6, setting/5, introduce_setting/5.

%%%
%%% Establish/1: drives backchaining to establish a proposition.
%%%
%%% This is writeen manually rather than using ==> because ==>
%%% automatically makes a predicate randomizable.  But we need
%%% control over the sequence the clauses are tried.
%%%

:- randomizable adds/2.
:- higher_order(establish(1, 0, 0, 0, 0)).
establish(Predicate, Plan, Plan, State, State) :-
   true_in_state(Predicate, State),
   !.
establish(Predicate, InPlan, OutPlan, InState, OutState) :-
   adds(Task, Predicate),
   call(Task, InPlan, OutPlan, InState, OutState).

:- higher_order(when(1, 0, 0, 0, 0, 0)).
when(Predicate, Task, InPlan, OutPlan, InState, OutState) :-
   Predicate,
   !,
   call(Task, InPlan, OutPlan, InState, OutState).
when(_Predicate, _Task, Plan, Plan, State, State).

:- higher_order(unless(1, 0, 0, 0, 0, 0)).
unless(Predicate, _Task, Plan, Plan, State, State) :-
   Predicate,
   !.
unless(_Predicate, Task, InPlan, OutPlan, InState, OutState) :-
   call(Task, InPlan, OutPlan, InState, OutState).

:- public add/5, invalidate/5.
%% add(+Fact)
%  Adds Fact to state.
add(Fact, Plan, Plan, State, NewState) :-
   add_all(State, [Fact], NewState).

%% invalidate(+Fact)
%  Rewmoves Fact from state.
invalidate(Fact, Plan, Plan, State, NewState) :-
   remove_all(State, [Fact], NewState).

%% setting(?Setting)
%  Establish that the action is taking place in SETTING.
setting(S) ==> establish(setting(S)).
beat(introduce_setting(Setting: setting) : { delete: setting(_), add: setting(Setting) },
     $text("Setting: [Setting]")).

stage_direction(introduce_setting(_)).

beat(time_passes : { delete: setting(_) },
     $text("Time passes..")).

stage_direction(time_passes()).
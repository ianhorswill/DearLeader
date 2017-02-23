:- public establish/5, when/6, unless/6, setting/5, introduce_setting/5.

%%%
%%% Establish/1: drives backchaining to establish a proposition.
%%%
%%% This is writeen manually rather than using ==> because ==>
%%% automatically makes a predicate randomizable.  But we need
%%% control over the sequence the clauses are tried.
%%%

empty_story(Plan, Plan, State, State).

:- public do/5, do/6, do/7, do/8, do/9.
do(Trope, InP, OutP, InS, OutS) :-
   call(Trope, InP, OutP, InS, OutS).
do(Trope, Arg1, InP, OutP, InS, OutS) :-
   call(Trope, Arg1, InP, OutP, InS, OutS).
do(Trope, Arg1, Arg2, InP, OutP, InS, OutS) :-
   call(Trope, Arg1, Arg2, InP, OutP, InS, OutS).
do(Trope, Arg1, Arg2, Arg3, InP, OutP, InS, OutS) :-
   call(Trope, Arg1, Arg2, Arg3, InP, OutP, InS, OutS).
do(Trope, Arg1, Arg2, Arg3, Arg4, InP, OutP, InS, OutS) :-
   call(Trope, Arg1, Arg2, Arg3, Arg4, InP, OutP, InS, OutS).

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

:- public narration/5.
beat(narration(Text),
     $text("[Text]")).
stage_direction(narration(_)).

montage(_Task, 0, Plan, Plan, State, State).
montage(Task, 1, InPlan, OutPlan, InState, OutState) :-
   call(Task, _, InPlan, OutPlan, InState, OutState).
montage(Task, 2, InPlan, OutPlan, InState, OutState) :-
   dif(Arg1, Arg2),
   call(Task, Arg1, InPlan, I1Plan, InState, I1State),
   call(Task, Arg2, I1Plan, OutPlan, I1State, OutState).
montage(Task, 3, InPlan, OutPlan, InState, OutState) :-
   dif(Arg1, Arg2, Arg3),
   call(Task, Arg1, InPlan, I1Plan, InState, I1State),
   call(Task, Arg2, I1Plan, I2Plan, I1State, I2State),
   call(Task, Arg3, I2Plan, OutPlan, I2State, OutState).
montage(Task, 4, InPlan, OutPlan, InState, OutState) :-
   dif(Arg1, Arg2, Arg3, Arg4),
   call(Task, Arg1, InPlan, I1Plan, InState, I1State),
   call(Task, Arg2, I1Plan, I2Plan, I1State, I2State),
   call(Task, Arg3, I2Plan, I3Plan, I2State, I3State),
   call(Task, Arg4, I3Plan, OutPlan, I3State, OutState).
montage(Task, 5, InPlan, OutPlan, InState, OutState) :-
   dif(Arg1, Arg2, Arg3, Arg4, Arg5),
   call(Task, Arg1, InPlan, I1Plan, InState, I1State),
   call(Task, Arg2, I1Plan, I2Plan, I1State, I2State),
   call(Task, Arg3, I2Plan, I3Plan, I2State, I3State),
   call(Task, Arg4, I3Plan, I4Plan, I3State, I4State),
   call(Task, Arg5, I4Plan, OutPlan, I4State, OutState).
montage(Task, 6, InPlan, OutPlan, InState, OutState) :-
   dif(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6),
   call(Task, Arg1, InPlan, I1Plan, InState, I1State),
   call(Task, Arg2, I1Plan, I2Plan, I1State, I2State),
   call(Task, Arg3, I2Plan, I3Plan, I2State, I3State),
   call(Task, Arg4, I3Plan, I4Plan, I3State, I4State),
   call(Task, Arg5, I4Plan, I5Plan, I4State, I5State),
   call(Task, Arg6, I5Plan, OutPlan, I5State, OutState).

%% escalation_sequence(Trope, Count)
%  Sequence of Count instances of Trope(N), with escalating values for N.
%  maximum_intensity(Trope, Max) must be defined, and Trope(N) must be defined
%  for all integers in 1..Max
escalation_sequence(Task, N) ==>
   { maximum_intensity(Task, Max) },
   escalation_sequence(Task, N, Max).
escalation_sequence(_Task, 0, _) ==> empty_story.
escalation_sequence(Task, Count, Count) ==>
   { !,
     Decremented is Count-1 },
   escalation_sequence(Task, Decremented, Decremented),
   do(Task, Count).
escalation_sequence(Task, Count, Max) ==>
   { !,
     random_integer(1, Max, Intensity),
     ReducedIntensity is Intensity-1,
     Decremented is Count-1 },
   escalation_sequence(Task, Decremented, ReducedIntensity),
   do(Task, Intensity).

%% Kluge because I never implemented a random_integer primitive
random_integer(1,1,1).
random_integer(1,2,X) :-
   random_member(X, [1,2]).
random_integer(1,3,X) :-
   random_member(X, [1,2,3]).
random_integer(1,4,X) :-
   random_member(X, [1,2,3,4]).
random_integer(1,5,X) :-
   random_member(X, [1,2,3,4,5]).
random_integer(1,6,X) :-
   random_member(X, [1,2,3,4,5,6]).

%% callback(Trope)
%  Repeats an instance of a Trope that has previously occurred
%  in the story.  Current implementation is restricted to single
%  beat tropes.
callback(Trope, InP, [Callback | InP], InState, OutState) :-
   call(Trope, [], [Callback], InState, OutState),
   memberchk(Callback, InP).
callback(Trope, InP, [Callback1, Callback2 | InP], InState, OutState) :-
   call(Trope, [], [Callback1, Callback2], InState, OutState),
   memberchk(Callback2, InP).

%% bookend(Trope, Bookend)
%  Begins and ends Trope with identical instances of Bookend.
:- public bookend/6.
bookend(Trope, Bookend) ==>
   Bookend,
   Trope,
   callback(Bookend).

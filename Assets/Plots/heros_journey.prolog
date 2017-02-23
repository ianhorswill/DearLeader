story : (protagonist(H), character(A), H \= A, genre(heros_journey)) ==>
   heros_journey(H, A).

heros_journey(H, A) ==>
   introduce_hero(H, _),
   antagonist_crosses_path(H, A, _),
   call_to_quest(H, A, _),
   quest(defeat_antagonist(H, A),
	 3).

subquest(defeat_henchpeep(H, Hench, A),
	 defeat_antagonist(H, A)) :-
   henchpeep(Hench, A),
   % This is a kluge; it's an idiom that will likely get used a lot
   % but I want a couple more use cases before I try to abstract it.
   \+ (memberchk(henchpeep(Hench), $story_setup)),
   bind(story_setup, [ henchpeep(Hench) | $story_setup ]).

subquest(S, defeat_henchpeep(H, Hench, _)) :-
   subquest(S, defeat_antagonist(H, Hench)).

:- public defeat_henchpeep/7.
defeat_henchpeep(H, Hench, _A) ==>
   defeat_antagonist(H, Hench).

finite(defeat_henchpeep(_, Hench, A)) -->
   [defeat], np(A), ["'s henchpeep"], np(Hench).

:- randomizable(henchpeep/2).
henchpeep(igor, _).
henchpeep(flying_monkeys, _).
henchpeep(fred_the_flying_robot, _).
henchpeep(henchbeing1, _).
henchpeep(henchbeing2, _).
henchpeep(henchbeing3, _).
henchpeep(henchbeing4, _).
henchpeep(henchbeing5, _).
henchpeep(henchbeing6, _).
henchpeep(henchbeing7, _).
henchpeep(henchbeing8, _).

beat(introduce_hero(H, farmer),
     $text("[H] grows up in a small farming town")).
beat(introduce_hero(H, orphan),
     $text("[H] is left on the steps of a monastery as a child")).
beat(introduce_hero(H, city),
     $text("[H] grows up in the big city, but always knew they were destined for something greater")).

beat(antagonist_crosses_path(H, A, destroys_home),
     $text("[A] Destroys the only home [H] had ever known.")).
beat(antagonist_crosses_path(_H, A, tyranny),
     $text("[A] Begins a tyrannical rule over the land")).
beat(antagonist_crosses_path(H, A, kills_family),
     $text("[A]'s actions lead to the death of [H]'s family.")).

beat(call_to_quest(H, A, revenge),
     $text("[H] Vows revenge against [A]")).
beat(call_to_quest(H, A, protection),
     $text("For the good of the people, [H] realizes they must defeat [A].")).
beat(call_to_quest(H, _A, chance_encounter),
     $text("[H] runs in fear, but a chance encounter makes them realize they can't run away from their problems.")).

beat(defeat_antagonist(H, A),
     $text("[H] defeats [A].")).

finite(defeat_antagonist(_, A)) -->
   [defeat], np(A).


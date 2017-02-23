story : (
	 genre(marital_drama),
	 theme(marriage),
	 theme(infidelity)
	) ==>
   loss_and_redemption_story(P, L, married(P, L)).

introduce_relationship(P, L, married(P, L)) : theme(marriage) ==>
   narrate_marriage_story(P, L),
   married_life(P, L, _),
   work_life(P),
   married_life(P, L, _).

beat(narrate_marriage_story(P, L),
      $text("[P] and [L]: a story of a marriage.")).
stage_direction(narrate_marriage_story(_,_)).

break_relationship(P, L, married(P, L)) : incompatibility(P, L, I) ==>
   argue_over(L, P, I),
   affair(P, L, A),
   affair_discovery(P, L, A),
   break_up(P, L),
   montage(depression_scene(P, loss_of_person(L)), 3).

restore_relationship(P, L, married(P, L)) ==>
   reunite(P, L).

loss_and_redemption_coda(P, L, married(P, L)) ==>
   callback(married_life(P, L, _)).

beat(married_life(P, L, shopping) :  { setting: supermarket },
     $text("[P] and [L] buy groceries together.")).

beat(married_life(P, L, morning_routine) :  { setting: home },
     $text("[P] and [L] make plans for the evening as they go about their morning ablutions")).
beat(married_life(P, L, making_breakfast) :  { setting: home },
     $text("[P] and [L] make plans for the evening as they eat their breakfast")).
beat(married_life(P, L, making_breakfast) :  { setting: home },
     $text("[P] returns home from work.  [P] and [L] talk about their days as they make dinner")).
beat(married_life(P, L, going_to_bed) :  { setting: home },
     $text("[P] and [L] read in bed together")).

affair(P, Spouse, A : character) : (
				    Spouse \= A,
				    theme(infidelity)
				   ) ==>
   introduce_relationship(P, A, lovers(P, A)).

beat(affair_discovery(P, L, _),
     $text("[L] discovers lipstick on [P]'s collar")).
beat(affair_discovery(P, L, _),
     $text("[L] discovers condoms in [P]'s pocket")).
beat(affair_discovery(P, L, A),
     $text("[L] discovers [P] in bed with [A]")).
beat(affair_discovery(P, L, A),
     $text("[L] discovers [P] texts to [A]")).
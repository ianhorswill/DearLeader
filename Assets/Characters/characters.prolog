:- randomizable character/1, interest/2, trait/2.

protagonist(X) :- character(X).

implies(protagonist(X), character(X)).
implies(protagonist(X), sympathetic(X)).

contradiction(sympathetic(X), unsympathetic(X)).

work_life(X) ==>
   work_interaction(X, _).

:- external sympathetic/1, unsympathetic/1.
:- randomizable beloved_of/2.

character(C) :-
   beloved_of(_, C),
   ground(C).

beloved_of(P, mother(P)).
np(mother(P)) -->
   np(P), ["'s mother"].
beloved_of(P, little_sister(P)).
np(little_sister(P)) -->
   np(P), ["'s little sister"].
beloved_of(P, little_brother(P)).
np(little_brother(P)) -->
   np(P), ["'s little brother"].
beloved_of(P, cat(P)).
np(cat(P)) -->
   np(P), ["'s cat"].


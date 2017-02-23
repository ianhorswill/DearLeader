:- public story/4, story/0.

symmetric(lovers(P, Q),
	  lovers(Q, P)).
generalization(lovers(P,Q), friends(P, Q)).
generalization(friends(P, Q), acquaintances(P, Q)).
symmetric(friends(P, Q),
	  friends(Q, P)).
symmetric(family(P, Q),
	  family(Q, P)).
symmetric(acquaintances(P, Q),
	  acquaintances(Q, P)).


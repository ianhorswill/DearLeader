introduce_relationship(P, L : character, lovers(P, L)) : (P \= L, compatibility(P, L, C)) ==>
   meet(P, L, _),
   fall_in_love(P, L, C),
   time_passes.

break_relationship(P, L, lovers(P, L)) : (P \= L, incompatibility(P, L, I)) ==>
   break_up_over(L, P, I),
   distraught(P).

restore_relationship(P, L, lovers(P, L)) ==>
   reunite(P, L).

loss_and_redemption_coda(P, L, lovers(P, L)) ==>
   happily_ever_after(P, L).

beat(happily_ever_after(A, B),
     $text("[A] and [B] live happily ever after")).

reunite(P, L) ==>
   saves_life(P, L),
   profess_love(L, P).
reunite(P, L) ==>
   saves_life(L, P),
   profess_love(L, P).
reunite(P, L) ==>
   attempt_suicide(P, _),
   prevents_suicide(L, P),
   profess_love(L, P).

fall_in_love(P, L, shared_interest(I)) ==>
   bond_over(P, L, shared_interest(I)),
   love_develops(P, L).

fall_in_love(P, L, shared_trait(T)) ==>
   bond_over(P, L, shared_trait(T)),
   love_develops(P, L).

beat(bond_over(A, B, Topic),
     $text("[A] and [B] bond over [Topic]")).
beat(love_develops(A, B) : { add: lovers(A, B) },
     $text("Love develops between [A] and [B]")).

beat(break_up_over(A, B, Topic),
     $text("[A] breaks up with [B] over [Topic]")).
beat(profess_love(A, B),
     $text("[A] professes their love to [B]")).

:- randomizable compatibility/3, incompatibility/3.

compatibility(C1, C2, shared_interest(Interest)) :-
   interest(C1, Interest),
   interest(C2, Interest).

compatibility(C1, C2, shared_trait(Trait)) :-
   trait(C1, Trait),
   trait(C2, Trait).

np(shared_trait(Trait)) --> np(Trait).

compatibility(_, _, shared_interest(lolcats)).
compatibility(_, _, shared_interest(love(dear_leader))).
compatibility(_, _, shared_interest(hate(negative_people))).

np(shared_interest(love(dear_leader))) --> ["their deep and abiding love of Dear Leader"].
np(shared_interest(hate(negative_people))) --> ["how they both hate people with negative energy"].
np(shared_interest(X)) -->
   {atom(X)}, [their, shared, interest, in], np(X).

incompatibility(C1, C2, unshared_interest2(Interest)) :-
   interest(C1, Interest),
   \+ interest(C2, Interest).
incompatibility(C1, C2, unshared_interest1(Interest)) :-
   interest(C2, Interest),
   \+ interest(C1, Interest).
incompatibility(C1, C2, incompatible_traits(C1:T1, C2:T2)) :-
   trait(C1, T1),
   trait(C2, T2).

np(unshared_interest1(X)) --> ["their lack of interest in"], np(X).
np(unshared_interest2(X)) --> ["their annoying interest in"], np(X).
np(incompatible_traits(C1:T1, _:_)) --> np(C1), [being], np(T1).

incompatibility(_, _, X) :-
   generic_incompatibility(X).

:- randomizable generic_incompatibility/1.
generic_incompatibility(squeezing_toothpaste_from_the_middle_of_the_tube).
generic_incompatibility(not_changing_the_toiletpaper_roll).
generic_incompatibility(snoring).

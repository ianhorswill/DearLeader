:- randomizable setting/1.
setting(malt_shop).
setting(starbucks).
proper_name(starbucks).
setting(cock_fight).
setting(bar).
setting(zombie_apocalypse).
setting(disco).
setting(art_opening).
setting(dmv).
setting(whole_foods).
proper_name(whole_foods).
setting(hospital).
setting(home(Who)) :- character(Who).
np(home(Who)) --> np(Who), ["'s home"].
setting(workplace(Who)) :- character(Who).
np(workplace(Who)) --> np(Who), ["'s workplace"].
setting(middle_of_the_night(home(Who))) :-
   ground(Who).
np(middle_of_the_night(S)) --> np(S), [", in the middle of the night"].

%%%
%%% LIFE THREATENING SITUATIONS AND RESCUES THEREFROM.
%%%

saves_life(Saver, Savee : character) : threatening_situation(Savee, Threat) ==>
   introduce_threat(Savee, Threat),
   rescue(Savee, Saver, Threat).

:- randomizable threatening_situation/2.

%%%
%%% Mugging
%%%

threatening_situation(_, mugger(_)).

introduce_threat(Victim, mugger(Mugger)) ==>
   mugs(Mugger, Victim).
rescue(_, Saver, mugger(Mugger)) ==>
   beats_up(Saver, Mugger).

beat(mugs(mugger, Victim) : { setting: a_dark_alley },
     $text("A mugger mugs [Victim]")).
beat(beats_up(Beater, Victim),
     $text("[Beater] beats up [Victim]")).

%%%
%%% Medical problems
%%%

:- randomizable medical_situation/1.

threatening_situation(P, medical_situation(P, M)) :-
   medical_situation(M).
threatening_situation(P, medical_situation(Who, M)) :-
   beloved_of(P, Who),
   medical_situation(M).

medical_situation(car_accident).
indefinite_article(car_accident).
medical_situation(cancer).
medical_situation(rare_disease).
indefinite_article(rare_disease).
np(medical_situation(X)) --> np(X).

introduce_threat(Victim, medical_situation(Who, What)) ==>
   life_threatened_by(Who, What),
   when(Victim \= Who, distraught(Victim)).

beat(life_threatened_by(Person, MedicalThreat) : { setting: hospital },
     $text("[Person]'s life is threatened by [MedicalThreat]")).

rescue(Rescued, Saver, medical_situation(Who, _)) : (medical_donation(Donation), character(Who)) ==>
   setting(hospital),
   gives(Saver, Who, Donation),
   when(Rescued \= Who,
	tearful_reunion(Rescued, Who)).

:- randomizable medical_donation/1.

medical_donation(blood).
medical_donation(kidney).
indefinite_article(kidney).
medical_donation(bone_marrow).
np(medical_donation(X)) --> np(X).

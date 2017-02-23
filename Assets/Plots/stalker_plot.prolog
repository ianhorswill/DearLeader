story : (theme(stalking), theme(love), genre(stalker), protagonist(Protagonist) ) ==>
   stalker_plot(Protagonist, _Stalker).

stalker_plot(P, S : character) : (P \= S) ==>
   introduce_relationship(P, S, lovers(P, S)),
   break_relationship(S, P, lovers(S, P)),  % P dumps S
   escalation_sequence(stalks(S, P), 3),    % S stalks P
   stalker_confrontation(P, S).             % S tries to kill P, P wins.

stalker_confrontation(P, S) ==>
   setting(home(P)),
   attempts_to_kill(S, P, _),
   kills(P, S, _).

:- public stalks/7.
maximum_intensity(stalks(_,_), 4).
beat(stalks(S, P, 1) : {setting: middle_of_the_night(home(P)) },
     $text("[S] texts [P]")).
beat(stalks(_, P, 2) : {setting: middle_of_the_night(home(P)) },
     $text("[P]'s phone rings, but there's nobody there.")).
beat(stalks(S, P, 3) : {setting: workplace(P) },
     $text("[S] comes to visit [P] at work.")).

stalks(S, P, 4) : ( character(O), O \= P, O \= S ) ==>
   introduce_relationship(P, O, lovers(P, O)),
   finds_body(P, O).
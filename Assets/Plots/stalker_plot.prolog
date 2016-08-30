story(Protagonist) ==>
   stalker_plot(Protagonist, _Stalker).

stalker_plot(P, S : character) : (P \= S, dif(Tone1, Tone2, Tone3)) ==>
   introduce_relationship(P, S, lovers(P, S)),
   break_relationship(P, S, lovers(P, S)),
   stalks(S, P, Tone1),
   stalks(S, P, Tone2),
   stalks(S, P, Tone3),
   stalker_confrontation(P, S).

stalker_confrontation(P, S) ==>
   setting(home(P)),
   attempts_to_kill(S, P, _),
   kills(P, S, _).

beat(stalks(_, P, creepy) : {setting: middle_of_the_night(home(P)) },
     $text("[P]'s phone rings, but there's nobody there.")).
beat(stalks(S, P, clueless) : {setting: middle_of_the_night(home(P)) },
     $text("[S] texts [P]")).
beat(stalks(S, P, threatening) : {setting: workplace(P) },
     $text("[S] comes to visit [P] at work.")).

stalks(S, P, really_scary) : ( character(O), O \= P, O \= S ) ==>
   introduce_relationship(P, O, lovers(P, O)),
   finds_body(P, O).
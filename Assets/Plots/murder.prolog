beat(kills(Killer, Victim, Instrument: murder_weapon),
     $text("[Killer] kills [Victim] with [Instrument]")).
beat(attempts_to_kill(Killer, Victim, Instrument: murder_weapon),
     $text("[Killer] tries to kill [Victim] with [Instrument]")).

:- randomizable(murder_weapon/1).
murder_weapon(gun).
murder_weapon(knife).
murder_weapon(nunchucks).
murder_weapon(bare_hands).
murder_weapon(hammer).

beat(finds_body(Finder, Victim),
     $text("[Finder] finds the body of [Victim].")).
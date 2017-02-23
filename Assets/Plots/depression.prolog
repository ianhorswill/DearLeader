%% depression_scene(Character, Cause, Manifestation)
%  Scene depicting Character's depression. Cause should be the cause of the
%  character's depression.

:- public depression_scene/7.
beat(depression_scene(Character, _, lie_in_bed),
     $text("[Character] lies in bed, staring at the ceiling.")).
beat(depression_scene(Character, _, eating_hagen_daz),
     $text("[Character] sits in front of the television, eating Hagen Daz.")).
beat(depression_scene(Character, _, drinking_alone),
     $text("[Character] stares at an empty whiskey bottle and cries.")).
beat(depression_scene(Character, _, loneliness),
     $text("[Character] walks the lonely streets at night, a hunch in their shoulders.")).
beat(depression_scene(Character, _, crying),
     $text("[Character] lies in bed, in the fetal position, quietly crying")).
beat(depression_scene(Character, _, gray_rain_of_depression),
     $text("[Character] walks through the lonely streets in the rain.")).
beat(depression_scene(Character, _, overcast),
     $text("[Character] walks along the streets, the sky overcast, the world uncaring.")).

beat(depression_scene(Character, loss_of_person(Lost), staring_at_photo),
     $text("[Character] stares longingly at a photo of [Lost]")).
beat(depression_scene(Character, loss_of_person(Lost), crying_over_photo),
     $text("[Character] stares longingly at a photo of [Lost] and cries.")).
beat(depression_scene(Character, loss_of_person(Lost), mistaken_identity),
     $text("[Character] sees [Lost], on the street, smiles, starts to say hello, but it's someone else.")).
beat(depression_scene(Character, loss_of_person(Lost), phone),
     $text("[Character] checks their smartphone, and sees an old call from [Lost].")).

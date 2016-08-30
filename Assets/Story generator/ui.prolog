:- public plan/2, plan/1.

plan(Task, Plan) :-
   step_limit(1000000),
   add_arguments(Task, [[], ReversedPlan, [], _], Goal),
   randomize(Goal),
   reverse(ReversedPlan, Plan).

plan(Task) :-
   plan(Task, Plan),
   print_all(Plan).

print_all(Plan) :-
   print_characters,
   print_setting,
   print_story(Plan),
   print_setup,
   nl.

print_characters :-
   displayln("<b>Dramatis personae</b>"),
   forall(member(character(C), $story_setup),
	  print_np(C)),
   nl.

print_np(X) :-
   np(X, Description, []),
   word_list(String, Description),
   print_capitalized(String),
   !.

print_capitalized(String) :-
   capitalized(String, Cap),
   displayln(Cap).

print_setting :-
   \+ member(setting(_), $story_setup).
print_setting :-
   displayln("<b>Locations</b>"),
   forall(member(setting(S), $story_setup),
	  print_np(S)),
   nl.

print_story(Plan) :-
   displayln("<b>The story</b>"),
   forall(member(Beat, Plan),
	  print_beat(Beat)).

print_beat(Beat) :-
   ignore(beat_preamble(Beat)),
   beat_description(Beat, Description),
   capitalized(Description, Cap),
   display(Cap),
   displayln("."),
   ignore(beat_postamble(Beat)),
   !.
print_beat(Beat) :-
   display("<i>"),
   write(Beat),
   displayln("</i>").

beat_preamble(Beat) :-
   stage_direction(Beat),
   display("\n<i>").
beat_postamble(time_passes()) :-
   display("</i>\n").
beat_postamble(Beat) :-
   stage_direction(Beat),
   display("</i>").

:- public print_setup/0.
print_setup :-
   nl,
   displayln("<b>Story elements</b>"),
   forall((member(X, $story_setup), X \= character(_), X \= setting(_)),
	  writeln(X)).

set_text(TextLines) :-
   concat(TextLines, Text),
   set_property($main_text::text, text, Text).

concat([], "").
concat([String | Rest], Out) :-
   concat(Rest, I),
   Out is $string.concat(String, "\n", I).

:- public new_story/0, show_cast/0, show_story/0, play_story/0.
new_story :-
   plan(story, Story),
   assert(/story:Story),
   assert(/setup: $story_setup),
   assert(/remaining_beats:Story),
   show_cast.

show_cast :-
   /setup:Setup,
   all(C, member(character(C), Setup), Characters),
   maplist(character_description, Characters, Lines),
   set_text(["<b>Cast</b>" | Lines]).

character_description(C, Description) :-
   np(C, Words, []),
   word_list(String, Words),
   capitalized(String, Description).

show_story :-
   /story:Story,
   maplist(beat_description_string, Story, Beats),
   set_text(Beats).

beat_description_string(Beat, Formatted) :-
   beat_description(Beat, String),
   capitalized(String, Description),
   formatted_beat_description(Beat, Description, Formatted).

formatted_beat_description(Beat, Description, Formatted) :-
   stage_direction(Beat),
   Formatted is $string.concat("<i>", Description, "</i>").
formatted_beat_description(_, Description, Description).

play_story :-
   remaining_beats(R),
   next_beat(R).

remaining_beats(R) :-
   /remaining_beats:R.
remaining_beats(R) :-
   /story:R.
remaining_beats(R) :-
   new_story,
   /story:R.

next_beat([]) :-
   set_text(["The end"]).
next_beat([Beat | Rest]) :-
   beat_description_string(Beat, Description),
   set_text([Description]),
   assert(/remaining_beats:Rest).


:- public plan/2, plan/1.

plan(Task, Plan) :-
   step_limit(1000000),
   add_arguments(Task,
		 [ [],              % input plan is empty
		   ReversedPlan,    % output plan
		   [],              % input state is empty
		   _                % ignore output state
		 ],
		 Goal),
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
   set_options_status(false),
   concat(TextLines, Text),
   set_property($main_text::text, text, Text).

concat([], "").
concat([String | Rest], Out) :-
   concat(Rest, I),
   Out is $string.concat(String, "\n", I).

:- public new_story/0, show_cast/0, show_story/0, play_story/0.
new_story :-
   set_options_status(false),
   initial_setup(I),
   bind(story_setup, I),
   catch(try_make_story,
	 Error,
	 begin(string_representation(Error, S),
	       set_text(["I got an error", S]))).

try_make_story :-
   plan(story, Story) -> setup_for_story(Story) ; set_text(["I can't think of any stories with those options.  Try giving me some more freedom."]).

setup_for_story(Story) :-
   assert(/story:Story),
   assert(/setup: $story_setup),
   assert(/remaining_beats:Story),
   show_cast.

initial_setup(I) :-
   /initial_setup:I, !.
initial_setup([]).

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

:- public show_options/0.

show_options :-
   set_text([]),
   set_options_status(true),
   all(String,
       (option(O), option_label_string(O, String)),
       Themes),
   set_toggles(Themes).

option_label_string(O, String) :-
   O =.. [Functor, Arg],
   word_list(String,
	     [Functor, ":", Arg]).

option(theme(T)) :-
   theme(T).
option(genre(T)) :-
   genre(T).

   % comma_separate(Themes, TString),
   % all(G, genre(G), Genres),
   % comma_separate(Genres, GString),
   % set_text(["<b>Themes</b>", TString, "", "<b>Genres</b>", GString]).

comma_separate([Singleton], Singleton).
comma_separate([S1 | Rest], Result) :-
   comma_separate(Rest, Suffix),
   Result is $string.concat(S1, ", ", Suffix).

options_gameobject(O) :-
   O is $'Canvas'.transform.find("Options").gameobject.

set_options_status(false) :-
   options_gameobject(O),
   O.activeinhierarchy,
   read_initial_setup_from_toggles(I),
   assert(/initial_setup:I),
   fail.
set_options_status(State) :-
   options_gameobject(O),
   O.setactive(State).

all_toggles(Toggles) :-
   all_toggle_positions(Unsorted),
   sort(Unsorted,Sorted),
   findall(T,
	   member((_:T), Sorted),
	   Toggles).

all_toggle_positions(Unsorted) :-
   options_gameobject(O),
   T is O.transform,
   all((Y:Child),
       (member(X, T), Child is X.gameobject, Y is -Child.transform.position.y),
       Unsorted).

set_toggles(List) :-
   all_toggles(T),
   set_toggles_aux(List, T).

set_toggles_aux([], []).
set_toggles_aux([], [H | T]) :-
   H.setactive(false),
   set_toggles_aux([], T).
set_toggles_aux([Name | MoreNames], [Toggle | MoreToggles]) :-
   Label is Toggle.transform.find("Label").gameobject,
   set_property(Label::text, "Text", Name),
   W is $color.white,
   set_property(Label::text, "Color", W),
   set_toggles_aux(MoreNames, MoreToggles).

read_initial_setup_from_toggles(L) :-
   all_toggles(Ts),
   all(~O,
       (member(T, Ts), T.activeinhierarchy, \+ checked(T), toggle_item(T, O)),
       L).

checked(T) :-
   T::toggle.ison.

toggle_item(T, Term) :-
   Text is (T.transform.find("Label").gameobject)::text.text.replace(":", ""),
   word_list(Text, List),
   Term =.. List.
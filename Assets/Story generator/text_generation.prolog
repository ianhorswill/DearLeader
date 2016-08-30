:- external indefinite_article/1, definite_article/1, proper_name/1.

compile_surface_form(Head, Expanded) :-
   dcg_from_parse(Expanded, In, Out, Body),
   simplify_conjunction(Body, Simplified),
   assert((beat_surface_form(Head, In, Out) :- Simplified)).

dcg_from_parse([], In, In, true).
dcg_from_parse([First | Rest], In, Out, (FirstBody, RestBody)) :-
   dcg_element(First, In, Intermediate, FirstBody),
   dcg_from_parse(Rest, Intermediate, Out, RestBody).
dcg_element([Escape], In, Out, Expanded) :-
   var(Escape),
   !,
   add_arguments(np(Escape), [In, Out], Expanded).
dcg_element([Escape], In, Out, Expanded) :-
   !,
   add_arguments(Escape, [In, Out], Expanded).
dcg_element(Word, [Word | Out], Out, true) :-
   atom(Word).
dcg_element(Bad, _, _, _) :-
   log(bad_text_element:Bad),
   fail.

:- external np/3, definite_article/1, indefinite_article/1.
np(X, [X | Out], Out) :-
   var(X),
   !.
np(X, [a, Words | Out], Out) :-
   atom(X),
   indefinite_article(X),
   atom_words(X, Words),
   !.
np(X, [the, Words | Out], Out) :-
   atom(X),
   atom_words(X, Words),
   definite_article(X),
   !.
np(X, [Words | Out], Out) :-
   atom(X),
   atom_words(X, Words),
   !.

:- public gen/1.

gen(Nonterminal) :-
   call(Nonterminal, Words, []),
   word_list(String, Words),
   displayln(String).

atom_words(X, Words) :-
   Words is X.tostring().replace("_", " ").

definite_article(X) :-
   (character(X) ; setting(X)),
   \+ proper_name(X).

beat_description(Beat, D) :-
   beat_surface_form(Beat, Surface, []),
   word_list(D, Surface),
   !.
beat_description(Beat, _) :-
   nlg_failure(Beat),
   fail.

nlg_failure(X) :-
   log(nlg_failed:X).
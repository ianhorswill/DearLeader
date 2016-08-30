%%%
%%% Beats related to suicide.
%%%

:- public commits_suicide/6.

beat(attempt_suicide(Person, Method:suicide_method) : { setting: home(Person) },
     $text("[Person] attempts suicide using [suicide_method(Method)]")).

beat(prevents_suicide(Preventer, Saved),
     $text("[Preventer] prevents [Saved] from committing suicide")).

beat(commits_suicide(Person, Method:suicide_method) : { setting: home(Person) },
     $text("[Person] commits suicide using [suicide_method(Method)]")).


:- randomizable suicide_method/1.
suicide_method(hanging).
suicide_method(gun).
suicide_method(electrocution).
suicide_method(poison).
suicide_method(sleeping_pills).
suicide_method(bomb).

np(suicide_method(M)) --> suicide_method(M).
suicide_method(Method) --> [Method].


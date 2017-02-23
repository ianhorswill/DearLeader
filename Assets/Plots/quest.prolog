:- external subquest/2.
:- randomizable subquest/2.

%% quest(PlotPoint, SubplotCount)
%  Generates narrative for achieving PlotPoint
%  using specified number of subplots
quest(PlotPoint, 0) ==> PlotPoint.
quest(PlotPoint, 1) : subquest(S, PlotPoint)  ==>
   introduce_subquest(S, PlotPoint),
   quest(S, 0),
   PlotPoint.
quest(PlotPoint, N)  ==>
   { N>1, pick_subquests(PlotPoint, N, S1, N1, S2, N2) },
   do_subquest(S1, N1, PlotPoint),
   do_subquest(S2, N2, PlotPoint),
   PlotPoint.

pick_subquests(PlotPoint, N, S1, N1, S2, N2) :-
   semieven_split(N, N1, N2),
   subquest(S1, PlotPoint),
   subquest(S2, PlotPoint),
   S1 \= S2.

do_subquest(Subquest, Subplots, ParentPlotPoint) ==>
   introduce_subquest(Subquest, ParentPlotPoint),
   quest(Subquest, Subplots).

beat(introduce_subquest(Sub, Super)
    % : {
    % 				       constraint: protagonist(P)
    %  }
    ,
     $text("Our hero knew that to [finite(Super)], they must first [finite(Sub)].")).
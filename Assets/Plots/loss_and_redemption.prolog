story(Protagonist) ==>
   loss_and_redemption(Protagonist).

loss_and_redemption(Protagonist) ==>
   introduce_relationship(Protagonist, Other, Relationship),
   break_relationship(Protagonist, Other, Relationship),
   restore_relationship(Protagonist, Other, Relationship),
   loss_and_redemption_coda(Protagonist, Other, Relationship).
character(barista).
interest(barista, arcade_fire).
interest(barista, coffee).
interest(barista, tamping).
trait(barista, poor).
trait(barista, hipster).

beat(work_interaction(barista, customer : walkon_character) : { setting: coffeehouse },
     $text("The barista makes an esspresso drink for a customer")).
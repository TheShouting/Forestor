local objectset = {}

objectset.actors = {

player = {
   name = "the player",
   character = "@",
   think = "player",
   color = {255, 255, 255},
   hands = true,
   img = 2,
   sprite = "player",
   corpse = 28,
   hp = 10,
   str = 3
   },
goblin = {
   name = "a goblin",
   character = "a",
   think = "fighter",
   color = {255, 255, 255},
   sprite = "goblin",
   hands = true,
   img = 3,
   corpse = 27,
   hp = 10,
   str = 2
   },
deer = {
   name = "a deer",
   character = "d",
   think = "coward",
   color = {255, 255, 255},
   img = 5,
   corpse = 27,
   hp = 5,
   str = 1
   },
table = {
   name = "a table",
   character = "[ ]",
   color = {255, 255, 255},
   imgr = 30,
   img = 31,
   imgl = 32
   },
portal = {
   name = "a touchstone",
   character = "$",
   color = {255, 128, 255, ember={255, 255, 255}},
   img = 8,
   }
}


objectset.props = {

axe={
   name= "axe",
   char= "q",
   img = 11,
   sprite = "axe",
   thumb = 12,
   hand = "right",
   key = "chop",
   dmg = 2,
   req=3
   },
sword={
   name = "sword",
   char = "\\",
   img = 9,
   sprite = "sword",
   thumb = 10,
   hand = "right",
   key = nil,
   dmg = 3,
   req=4
   },
shield = {
   name = "shield",
   char = "\\",
   img = 17,
   thumb = 18,
   hand = "left",
   key = nil,
   def = 2,
   req=4
   },
potion = {
   name = "health potion",
   char = "'",
   thumb = 26,
   sprite = "potion",
   consume = "heal",
   auto = true,
   pickup = function(self, actor)
         actor.hp = actor.hp + 2
      end
   },
hammer={
   name= "hammer",
   char= "7",
   img = 13,
   sprite = "hammer",
   thumb = 14,
   hand = "right",
   dmg = 1,
   req=4,
   knockback = 2,
   hit = function(self, owner, other)
         other:setstatus("stun", 1)
      end
   }
}

return objectset
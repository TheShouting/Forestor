local objectset = {}

objectset.actors = {

player = {
   name = "the player",
   character = "@",
   think = "player",
   color = {255, 255, 255},
   img = 2,
   corpse = 28,
   hp = 100,
   str = 20
   },
goblin = {
   name = "a goblin",
   character = "a",
   think = "fighter",
   color = {255, 255, 255},
   img = 3,
   corpse = 27,
   hp = 100,
   str = 20
   },
deer = {
   name = "a deer",
   character = "d",
   think = "coward",
   color = {255, 255, 255},
   img = 5,
   corpse = 27,
   hp = 50,
   str = 5
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
   thumb = 12,
   hand = "right",
   key = "chop",
   dmg = 10
   },
sword={
   name = "sword",
   char = "\\",
   img = 9,
   thumb = 10,
   hand = "right",
   key = nil,
   dmg = 30
   },
shield = {
   name = "shield",
   char = "\\",
   img = 17,
   thumb = 18,
   hand = "left",
   key = nil,
   def = 20
   },
potion = {
   name = "health potion",
   char = "'",
   thumb = 26,
   consume = "heal",
   pickup = function(self, actor)
         actor.hp = actor.hp + 15
      end
   },
hammer={
   name= "hammer",
   char= "7",
   img = 13,
   thumb = 14,
   hand = "right",
   dmg = 10,
   knockback = 1,
   hit = function(self, owner, other)
         other:setstatus("stun", 1)
      end
   }
}

return objectset
local objectset = {}

objectset.actors = {

player = {
   name = "the player",
   character = "@",
   think = "player",
   img = 1,
   hp = 100,
   str = 20
   },
goblin = {
   name = "a goblin",
   character = "a",
   think = "coward",
   img = 2,
   hp = 80,
   str = 20
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
   val = 10
   },
sword={
   name = "sword",
   char = "\\",
   img = 9,
   thumb = 10,
   hand = "right",
   key = nil,
   val = 30
   },
shield = {
   name = "shield",
   char = "\\",
   img = 17,
   thumb = 18,
   hand = "left",
   key = nil,
   val = 20
   }

}

return objectset
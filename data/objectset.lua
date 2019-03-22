local objectset = {}

objectset.actors = {

player = {
   name = "the player",
   character = "@",
   think = "player",
   color = {255, 255, 255},
   img = 2,
   hp = 100,
   str = 20
   },
goblin = {
   name = "a goblin",
   character = "a",
   think = "drunk",
   color = {255, 255, 255},
   img = 3,
   hp = 80,
   str = 20
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
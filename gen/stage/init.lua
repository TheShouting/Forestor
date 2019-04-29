local room = require("gen.stage.room")
local pond = require("gen.stage.pond")
local meadow = require("gen.stage.meadow") 


local stage = {
   start = {
      meadow
   },
   finish = {
      room
   },
   endpoint = {
      room,
      meadow
   },
   crossroad = {
      meadow
   },
   passage = {
      meadow
   }
}
   
return stage
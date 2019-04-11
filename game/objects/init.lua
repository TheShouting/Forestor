local _path = "game.objects."

local objects = {
   prop = require(_path.."prop"),
   entity = require(_path.."entity"),
   actor = require(_path.."actor"),
   dummy = require(_path.."dummy"),
   player = require(_path.."player")
   }
   
return objects
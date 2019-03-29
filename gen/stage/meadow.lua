local tools = require("gen.tools")

local meadow = { 
   ... --meta-fields here 
   } 
   
meadow.meadow = function(map, path, x, y, rng, key) 
   local rad = rng:random()*3 + 2
   
   local rpos = math.floor(rad)
   
   local meadow =
      tools.make(rpos*2+1, rpos*2+1, "blank")
      
   tools.clear(meadow, rpos+1, rpos+1, rad, "grass")
   tools.noise(meadow, 0.05, "flower", rng)
   
   local rx = x - rpos - 1
   local ry = y - rpos - 1
   tools.apply(map, meadow, "blank", rx, ry)
   
   return keyobject
   
end 

setmetatable(meadow, { 
   __call = function(_, map, x, y, rng, key) 
      return meadow.meadow(map, x, y, rng, key)
   end 
   }) 
   
return meadow
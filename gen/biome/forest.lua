local tools = require("gen.tools")

local forest = { 
   ... --meta-fields here 
   } 
   
forest.forest = function(level, rng)
   local map = tools.copy(level)
   --tools.grow(map, true, 1)
   
   --local trees = make(map.w, map.h, "tree")
   
   tools.replace(map, false, "tree")
   tools.replace(map, true, "grass")
   
   tools.noise(map, 0.4, "grass", rng)
   for i = 1, 3 do
      tools.cellauto(map, "tree", "grass")
   end
   
   tools.stencil(map, level, true, "grass")
   
   local ground = tools.make(map.w, map.h, "dirt")
   tools.noise(ground, 0.5, "grass", rng)
   for i = 1, 2 do
      tools.cellauto(ground, "grass", "dirt")
   end
   tools.apply(ground, map, "grass")
   tools.stencil(ground, level, true, "path")
   
   local grass = tools.make(map.h, map.w, "dirt")
   tools.noise(grass, 0.35, "tallgrass", rng)
   for i = 1, 3 do
      tools.cellauto(grass, "tallgrass", "dirt")
   end
   
   tools.apply(ground, grass, "dirt")
   
   map = tools.apply(ground, map, "grass")
   
   return map
   
end 

setmetatable(forest, { 
   __call = function(_, map, rng) 
      return forest.forest(map, rng)
   end 
   }) 
   
return forest
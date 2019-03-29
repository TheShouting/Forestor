local tools = require("gen.tools")

local empty = { 
   ... --meta-fields here 
   } 
   
empty.empty = function(level, rng)
   local w = level.w
   local h = level.h
   local map = tools.make(w, h, "blank")
   local path = tools.make(w, h, false)
   
   for i = 1, #level do
      local neighbors = level[i].neighbors
      for _, n in pairs(neighbors) do
			      if n > i then
						      tools.line(path, 
						         level[i].x, level[i].y, 
						         level[n].x, level[n].y, true)
			      end
      end
   end
   
   tools.stencil(map, path, true, "path")
   
   return map, path
end 

setmetatable(empty, { 
   __call = function(_, map, rng) 
      return empty.empty(map, rng)
   end 
   }) 
   
return empty
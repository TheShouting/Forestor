local tools = require("gen.tools")

local room = { 
   ... --meta-fields here 
   } 
   
room.room = function(map, path, x, y, rng, key) 
   local w = rng:random(2, 4)
   local h = rng:random(2, 4)
   
   local room = tools.room(w, h, "wall", "dirt")
   
   --[[
   tools.door(room, 
      rng:random(map.w), 
      rng:random(map.h),
      "doorclose")
   --]]
   
   local rx = x - math.floor(w * 0.5 + 0.5) - 1
   local ry = y - math.floor(h * 0.5 + 0.5) - 1
   tools.apply(map, room, nil, rx, ry)
   
   for x = 1, room.w do
      for y = 1, room.h do
         local px = 
            (x + rx + map.w - 1) % map.w + 1
         local py = 
            (y + ry + map.h - 1) % map.h + 1
         if x == 1 or x == room.w or
            y == 1 or y == room.h then
            if path[px][py] then
               map[px][py] = "doorclose"
            end
         end
      end
   end
   
   return nil
   
end 

setmetatable(room, { 
   __call = function(_, map, x, y, rng, key) 
      return room.room(map, x, y, rng, key)
   end 
   }) 
   
return room
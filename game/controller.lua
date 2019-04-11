--local world = require("game.world")

controller = {}

controller.player = function(a, w)
   local input = controller.playerinput
   controller.playerinput = nil
   return input
end

controller.fighter = function(a, w)
   local r = 4

   local t = w.player.pos
   local o = a.pos
   if w.player.alive then
			   if w.dist(o.x, o.y, t.x, t.y) < r*r then
						   if w.ray(o.x, o.y, t.x, t.y) then
						      return controller.seek(a, w)
						   end
			   end
   end
   
   return controller.drunk(a, w)
end

controller.coward = function(a, w)
   local r = 4

   local t = w.player.pos
   local o = a.pos
   if w.dist(o.x, o.y, t.x, t.y) < r*r then
			   if w.ray(o.x, o.y, t.x, t.y) then
			      return controller.flee(a, w)
			   end
   end
   
   return controller.wander(a, w)
end

controller.wander = function(a, w)
   local dir = {
      {x=0,y=0},
      {x=1,y=0},
      {x=0,y=0},
      {x=-1,y=0},
      {x=0,y=-1}
   }
   for i, d in pairs(dir) do
      local sx = a.pos.x + d.x
      local sy = a.pos.y + d.y
      
      local open = w.open(sx, sy)
      local key = a:haskey(w.key(sx, sy))
      
      if not open or (not open and not key) then 
         table.remove(dir, i)
      end
   end
   if #dir > 0 then
      return dir[love.math.random(#dir)]
   else
      return {x=0, y=0}
   end
end

controller.drunk = function(a, w)
   local dir = {
      {x=0,y=0},
      {x=1,y=0},
      {x=0,y=1},
      {x=-1,y=0},
      {x=0,y=-1}
   }
   return dir[love.math.random(#dir)]
end

controller.navigate = function(a, w)
   local t = w.player.pos
   return w.path(a.pos.x, a.pos.y, t.x, t.y)
end

controller.seek = function(a, w)
   local s4 = {
      {x=1, y=0},
      {x=0, y=1},
      {x=-1, y=0},
      {x=0, y=-1}
   }

   local ox = a.pos.x
   local oy = a.pos.y
   local tx = w.player.pos.x
   local ty = w.player.pos.y
   
   local npath = {x=0, y=0}
   
   local dist =
      w.width * w.width + w.height * w.height
   for i = 1, #s4 do
      local sx = ox + s4[i].x
      local sy = oy + s4[i].y
      
      local open = w.open(sx, sy)
      local key = a:haskey(w.key(sx, sy))
      
      if open or (not open and key) then
         local dx = math.min(
            math.abs(tx - sx), 
            math.abs(tx - sx - w.width))
         local dy = math.min(
            math.abs(ty - sy), 
            math.abs(ty - sy - w.height))
         if (dx*dx + dy*dy < dist) then
            dist = dx*dx + dy*dy
            npath = s4[i]
         end
      end
   end
   
   return npath
end

controller.flee = function(a, w)
   local s4 = {
      {x=1, y=0},
      {x=0, y=1},
      {x=-1, y=0},
      {x=0, y=-1}
   }

   local ox = a.pos.x
   local oy = a.pos.y
   local tx = w.player.pos.x
   local ty = w.player.pos.y
   local npath = {x=0, y=0}
   local dist = 0
   for i = 1, #s4 do
      local sx = ox + s4[i].x
      local sy = oy + s4[i].y
      
      local open = w.open(sx, sy)
      local key = a:haskey(w.key(sx, sy))
      
      if open or (not open and key) then
         local dx = math.min(
            math.abs(tx - sx), 
            math.abs(tx - sx - w.width))
         local dy = math.min(
            math.abs(ty - sy), 
            math.abs(ty - sy - w.height))
         if (dx*dx + dy*dy > dist) then
            dist = dx*dx + dy*dy
            npath = s4[i]
         end
      end
   end
   
   return npath
end


return controller

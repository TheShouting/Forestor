controller = {}

controller.playerinput = {x=0, y=0}

controller.player = function(a, w)
   return controller.playerinput
end

controller.coward = function(a, w)

   local t = w.player.pos
   local o = a.pos
   
   if w.ray(o.x, o.y, t.x, t.y) then
      return controller.flee(a, w)
   else
      return controller.wander(a, w)
   end

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
      if not w.open(
         a.pos.x + d.x, a.pos.y + d.y, a:key())
      then
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
      {x=0,y=0},
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
      local s = w.pos(ox + s4[i].x, oy + s4[i].y)
      if w.open(s.x, s.y, a:key()) then
         local dx = math.min(
            math.abs(tx - s.x), 
            math.abs(tx - s.x - w.width))
         local dy = math.min(
            math.abs(ty - s.y), 
            math.abs(ty - s.y - w.height))
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
      local s = w.pos(ox + s4[i].x, oy + s4[i].y)
      if w.open(s.x, s.y, a:key()) then
         local dx = math.min(
            math.abs(tx - s.x), 
            math.abs(tx - s.x - w.width))
         local dy = math.min(
            math.abs(ty - s.y), 
            math.abs(ty - s.y - w.height))
         if (dx*dx + dy*dy > dist) then
            dist = dx*dx + dy*dy
            npath = s4[i]
         end
      end
   end
   
   return npath
end




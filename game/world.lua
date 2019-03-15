-- World handler

local objects = require("game.objects")
local mapset = require("data.mapset")

local world = {}

world.set = mapset
         
function world.new(width, height)
   world.width = width or 0
   world.height = height or 0
   world.map = {}
   world.actor = {}
   world.prop = {}
   world.player = {}
   world.timer = 0.0
   
   local tkeys = {}
   for k, v in pairs(world.set) do
      table.insert(tkeys, k)
   end
   
   for x=1, world.width do
      world.map[x] = {}
      for y=1, world.height do
         world.map[x][y] = {
            id = "dirt",
            rand = love.math.random(0, 99),
            see = false
         }
      end
   end
   
   world.player = objects.player(100,25)
   local monster =
      objects.actor("coward")
   monster.right = objects.prop(
      "P","right","axe",10,"axe")

   world.insert(world.player, 1, 1)
   world.insert(monster, 5, 3)
   world.insert(objects.actor(nil), -2, -2)
   
   world.map[4][2].prop = 
      objects.prop("/", "right", "sword")
   world.map[2][5].prop = 
      objects.prop("0", "left", "shield")
      
   world.player.message = "I see forest..."
   
end

-- Fill map
function world.fill(map)
   for x=1, map.w do
      for y=1, map.h do
         world.map[x][y].id = map[x][y]
      end
   end
   
   world.floodview(
      world.player.pos.x, world.player.pos.y, 5
   )
end

-- Return new position within the map
function world.pos(px, py)
   return {
      x = ((px - 1) % world.width) + 1, 
      y = ((py - 1) % world.height) + 1
   }
end

-- Get display characters for specified position
function world.char(x, y)
   local pos = world.pos(x, y)
   local cell = world.map[pos.x][pos.y]
   if (cell.see) then
      if (cell.obj) then
         return cell.obj:char()
      else
         if (cell.prop) then
            return " "..cell.prop.char.." "
         else
            local c = 
               cell.rand %
                  #world.set[cell.id].char
            return world.set[cell.id].char[c + 1]
         end
      end
   else
      return "   "
   end
end

function world.name(x, y)
   local pos = world.pos(x, y)
   local cell = world.map[pos.x][pos.y]
   if (cell.prop) then
      return cell.prop.name
   else
      return world.set[cell.id].name
   end
end

-- Get display color for specified position
function world.col(x, y)
   local pos = world.pos(x, y)
   local cell = world.map[pos.x][pos.y]
   if (cell.see) then
			   if (cell.obj) then
			      return cell.obj:col()
			   else
			      if (cell.prop) then
			         local col={200, 200, 200}
			         col.sin = {100,100,100}
			         return col
			      else
			         local col = 
			            world.mapColor(pos.x, pos.y)
			         if (cell.hitdelay) then
			            col.blink ={255,255,255}
			         end
			         return col
			      end
			   end
   end
   return {0,0,0}
end

function world.getActor(x, y)

   local p = world.pos(x, y)
   return world.map[p.x][p.y].obj

end

function world.mapColor(x, y)
   local pos = world.pos(x, y)
   local cell = world.map[pos.x][pos.y]
   local color = world.set[cell.id].color
   local c = color[cell.rand %
      #world.set[cell.id].color +1]
      
   local col = {}
   for k, v in pairs(c) do
      col[k] = v
   end
   ---local col = {c[1], c[2], c[3]}
   if (not cell.mem) then
      col.blink = {0,0,0}
   end
   
   return col
end

-- Move object in world
function world.move(obj, x, y)
   local npos = world.pos(x, y)
   local newcell = world.map[npos.x][npos.y]
   
   if (newcell.obj == nil) then
      local pos = obj.pos
      local oldcell = world.map[pos.x][pos.y]
      oldcell.obj = nil
      newcell.obj = obj
      obj.pos = npos
      
      if (world.set[oldcell.id].leave) then
         oldcell.id = world.set[oldcell.id].leave
      end
      
      return nil
   else
      local mo = world.map[npos.x][npos.y].obj
      if (mo ~= obj) then
         return mo
      else
         return nil
      end
   end
end

-- move actor across the map
function world.shift(obj, x, y)
   local pos = 
      world.pos(obj.pos.x + x, obj.pos.y + y)
   local cell = world.map[pos.x][pos.y]
   local id = cell.id
   
   if (world.set[cell.id].hit) then
      local k = world.set[id].key
      if (k) then
         if (k == obj:key()) then
            cell.id = world.set[cell.id].hit
         else
            obj.message = "I need "..k.."!"
         end
      else
         cell.id = world.set[cell.id].hit
      end
   end
   
   if (world.set[id].move) then
      return world.move(obj, pos.x, pos.y)
   else
      cell.hit = true
      return nil
   end
end

function world.open(x, y, key)
   local p = world.pos(x, y)
   local id = world.map[p.x][p.y].id
   if key then
      if world.set[id].key then
         return world.set[id].key == key
      end
   end
   return world.set[id].move
end

-- insert actor in world
function world.insert(obj, x, y)
   local pos = world.pos(x, y)
   if (world.map[pos.x][pos.y].obj == nil) then
      i = #world.actor + 1
      world.actor[i] = obj
      obj.pos = pos
      world.map[pos.x][pos.y].obj = obj
      return i
   else
      return 0
   end
end

function world.flush()
   for x=1, world.width do
      for y=1, world.height do
         local cell = world.map[x][y]
         cell.mem = cell.see
         cell.see = false
         cell.hitdelay = cell.hit
         cell.hit = nil
      end
   end
end

function world.fov(vx, vy, range)
   world.map[vx][vy].see  = true
   for x = -range, range do
      for y = -range, range do
         if ((x*x + y*y) < range*range) then
            local p = world.pos(vx+x, vy+y)
            local cell = world.map[p.x][p.y]
            cell.see =
               world.ray(vx, vy, vx + x, vy + y)
         end
      end
   end
end

function world.floodview(x, y, range, cx, cy)

   if (cx and cy) then
      local r = (cx-x)*(cx-x)+(cy-y)*(cy-y)
      if (r > range*range) then
         return nil
      end
   else
      cx = x
      cy = y
   end

   local s8 = {{1,0}, {1,1}, {0,1}, {-1,1},
        {-1,0},{-1,-1},{0, -1},{1, -1}}

   for k, v in pairs(s8) do
      local nx = v[1] + cx
      local ny = v[2] + cy
      local pos = world.pos(nx, ny)
      local cell = world.map[pos.x][pos.y]
      local check = not cell.see
      cell.see = true
      if (world.set[cell.id].see and check) then
         world.floodview(x, y, range, nx, ny)
      end
   end

end

function world.path(ox, oy, tx, ty)

   local s4 = {
      {x=1, y=0},
      {x=0, y=1},
      {x=-1, y=0},
      {x=0, y=-1}
   }

   local npath = {x=0, y=0}
   local dist = 
      world.width * world.width +
      world.height * world.height + 10
   for i = 1, #s4 do
      local dir = s4[i]
      local pos = world.pos(dir.x + ox,dir.y + oy)
      local cell = world.map[pos.x][pos.y].id
      if (world.set[cell].move) then
         local dx = math.min(
            math.abs(tx - pos.x), 
            math.abs(tx + world.width - pos.x))
         local dy = math.min(
            math.abs(ty - pos.y), 
            math.abs(ty + world.height - pos.y))
         if (dx*dx + dy*dy < dist) then
            dist = dx*dx + dy*dy
            npath = dir
         end
      end
   end
   
   return npath
end

function world.rpath()
   local dir = {
      {x=0,y=0},
      {x=1,y=0},
      {x=0,y=0},
      {x=-1,y=0},
      {x=0,y=-1}
   }
   return dir[love.math.random(#dir)]
end

function world.distsq(x1, y1, x2, y2)
   --local minx = math.min(x1 - x2, x1 + world.width - x2)
end

function world.ray(x1, y1, x2, y2)

   local tx = y2 - world.width
   local ty = y2 - world.height
   
   if math.abs(tx - x1) < math.abs(x2 - x1) then
      x2 = tx
   end
   if math.abs(ty - y1) < math.abs(y2 - y1) then
      y2 = ty
   end
   
   local delta_x = x2 - x1 
   local ix = delta_x > 0 and 1 or -1 
   delta_x = 2 * math.abs(delta_x)
   
   local delta_y = y2 - y1 
   local iy = delta_y > 0 and 1 or -1 
   delta_y = 2 * math.abs(delta_y)
   
   if delta_x >= delta_y then
      local err = delta_y - delta_x / 2
      
      while (math.abs(x1-x2) > 1) do
         if ((err > 0) or (err == 0 and ix > 0))
         then
            err = err - delta_x
            y1 = y1 + iy
         end
         
         err = err + delta_y
         x1 = x1 + ix
         
         local pos = world.pos(x1, y1)
         local cell = world.map[pos.x][pos.y]
         if (not world.set[cell.id].see) then
            return false
         end
      end
   else
      local err = delta_x - delta_y / 2
      
      while math.abs(y1 - y2) > 1 do
         if ((err > 0) or (err == 0 and iy > 0))
         then
            err = err - delta_y
            x1 = x1 + ix
         end
         err = err + delta_x
         y1 = y1 + iy
         
         local pos = world.pos(x1, y1)
         local cell = world.map[pos.x][pos.y]
         if (not world.set[cell.id].see) then
            return false
         end
      end
   end
   
   return true
end


-------------------------------------------------
-- Game update method ---------------------------
-------------------------------------------------
function world.update(x, y)
   
   world.message = nil
   
   --world.player:command(x, y)
   controller.playerinput = {x=x, y=y}
   
   for i, actor in  ipairs(world.actor) do
      local cell = 
         world.map[actor.pos.x][actor.pos.y]
      if (actor.alive) then
         -- move and update actor
         local move = actor:update(world)
         if (move.x == 0 and move.y == 0) then
            if (cell.prop) then
               actor.message = "I have "..
                  cell.prop.name.."!"
               cell.prop:pickup(actor, world)
            end
         else
            local other = 
               world.shift(actor, move.x, move.y)
            if (other) then
               other:push(actor)
               actor.message = 
                  "I hit "..other:getName().."!"
            end
         end
         -- Apply tile effects
         local ncell = 
            world.map[actor.pos.x][actor.pos.y]
         local effect =
            world.set[ncell.id].effect
         if (effect) then
            for e, t in pairs(effect) do
               actor.effect[e] = t
            end
         end
      else
         if (actor.rot == 0) then
            local prop = actor:die(world)
            if (not cell.prop) then
               cell.prop = prop
            end
            cell.obj = nil
            world.actor[i] = nil
         else
            actor.rot = actor.rot - 1
         end
      end
   end
   
   world.flush()
   
   world.map[world.player.pos.x]
      [world.player.pos.y].see = true
   
   world.floodview(
      world.player.pos.x, world.player.pos.y, 5
   )
   
   if not world.message and
      world.player.effect.hit 
      then
      local hm ={
         "Ouch!", 
         "Oomf!", 
         "Ha!", 
         "Grr!",
         "Eeow!",
         "Ow!",
         "Gaah!"
         }
      world.message = hm[love.math.random(#hm)]
   end
   
end


return world


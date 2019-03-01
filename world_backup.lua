-- World class ----------------------------------
World = {}
World.__index = World
setmetatable(World, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function World:_init(width, height)
   self.width = width or 0
   self.height = height or 0
   self.map = {}
   self.actor = {}
   self.prop = {}
   self.player = {}
   self.message = "I see forest..."
   
   self.set = {
      puddle = {
         name = "puddle",
         char={" ~ "}, 
         color={{20, 60, 100}}, 
         move=true,
         see=true,
         effect={wet=3}
      },
      dirt = {
         name = "dirt",
         char={" . "}, 
         color={{80, 60, 20}}, 
         move=true,
         see=true
      },
      flower = {
         name = "flower",
         char={" * ", ".*."}, 
         color={
            {156, 156, 72},
            {156, 128, 60},
            {156, 128, 128}
            }, 
         move=true,
         see=true
      },
      grass = {
         name = "grass",
         char={".v.", "..."}, 
         color={{20, 80, 10}}, 
         move=true,
         see=true
      },
      tallgrass = {
         name = "tall grass",
         char={"iii"},
         color={{50, 120, 30}}, 
         move=true,
         see=false,
         hit = "grass",
         key = nil
      },
      tree = {
         name = "big trees",
         char={"/\\\\", "//\\", "/V\\"}, 
         color={
            {100, 200, 50},
            {150, 200, 50}
            }, 
         move=false,
         see=false,
         hit = "treesmall",
         key = "axe"
      },
      treesmall = {
         name = "trees",
         char = {"/\\_", "^/\\", "./\\"},
         color={
            {100, 200, 50},
            {150, 200, 50}
            },
         move = false,
         see = false,
         hit = "stump",
         key = "axe"
      },
      stump = {
         name = "log",
         char={"c=o"}, 
         color={{200, 120, 90}}, 
         move=false,
         see=true,
         hit="twig",
         key="axe"
      },
      twig = {
         name = "broken branches",
         char={"-=_","-_-","=-=","=_-", "_=_"}, 
         color={{100, 80, 70}}, 
         move=true,
         see=true
      },
      dooropen = {
         name = "open door",
         char = {"|_|"},
         color = {{128, 128, 128}},
         move = true,
         see = true,
         leave = "doorclose",
      },
      doorclose = {
         name = "closed door",
         char = {"|O|"},
         color = {{200, 200, 200}},
         move = false,
         see = false,
         hit = "dooropen"
      },
      doorlocked = {
         name = "locked door",
         char = {"|X|"},
         color = {{200, 200, 200}},
         move = false,
         see = false,
         hit = "dooropen",
         key = "key"
      },
      wall = {
         name = "wall",
         char = {"|#|"},
         color = {{200, 200, 200}},
         move = false,
         see = false
      },
      cliff = {
         name = "cliff",
         char = {"%%%"},
         color = {{180, 140, 80}},
         move = false,
         see = false,
         hit = "rubble",
         key = "pickaxe"
      },
      rubble = {
         name = "rocks",
         char = {"oO°", "OoO", "0oO"},
         color = {{200, 160, 100}},
         move = false,
         see = true,
         hit = "dirt",
         key = "pickaxe"
      }
   }
   
   local tkeys = {}
   for k, v in pairs(self.set) do
      table.insert(tkeys, k)
   end
   
   for x=1, self.width do
      self.map[x] = {}
      for y=1, self.height do
         self.map[x][y] = {
            id = "dirt",
            rand = love.math.random(0, 99),
            see = false
         }
      end
   end
   
   self:floodview(1, 1, 5)
   
   self.player = Player(100,25)
   local monster = Actor("A", 100, 10, "monster")
   monster.right = 
      Prop("P", "right", "axe", 10, "axe")

   self:insert(self.player, 1, 1)
   self:insert(monster, 5, 3)
   
   self.map[4][2].prop = 
      Prop("/", "right", "sword")
   self.map[2][5].prop = 
      Prop("0", "left", "shield")
end

-- Fill map
function World:fill(map)
   for x=1, map.w do
      for y=1, map.h do
         self.map[x][y].id = map[x][y]
      end
   end
end

-- Return new position within the map
function World:pos(px, py)
   return {
      x = ((px - 1) % self.width) + 1, 
      y = ((py - 1) % self.height) + 1
   }
end

-- Get display characters for specified position
function World:char(x, y)
   local pos = self:pos(x, y)
   local cell = self.map[pos.x][pos.y]
   if (cell.see) then
      if (cell.obj) then
         return cell.obj:char()
      else
         if (cell.prop) then
            return " "..cell.prop.char.." "
         else
            local c = 
               cell.rand %
                  #self.set[cell.id].char
            return self.set[cell.id].char[c + 1]
         end
      end
   else
      return "   "
   end
end

function World:name(x, y)
   local pos = self:pos(x, y)
   local cell = self.map[pos.x][pos.y]
   if (cell.prop) then
      return cell.prop.name
   else
      return self.set[cell.id].name
   end
end

-- Get display color for specified position
function World:col(x, y)
   local pos = self:pos(x, y)
   local cell = self.map[pos.x][pos.y]
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
			            self:mapColor(pos.x, pos.y)
			         if (cell.hitdelay) then
			            col.blink ={255,255,255}
			         end
			         return col
			      end
			   end
   end
   return {0,0,0}
end

function World:mapColor(x, y)
   local pos = self:pos(x, y)
   local cell = self.map[pos.x][pos.y]
   local color = self.set[cell.id].color
   local c = color[cell.rand %
      #self.set[cell.id].color +1]
   local col = {c[1], c[2], c[3]}
   if (not cell.mem) then
      col.blink = {0,0,0}
   end
   
   return col
end

-- Move object in world
function World:move(obj, x, y)
   local npos = self:pos(x, y)
   local newcell = self.map[npos.x][npos.y]
   
   if (newcell.obj == nil) then
      local pos = obj.pos
      local oldcell = self.map[pos.x][pos.y]
      oldcell.obj = nil
      newcell.obj = obj
      obj.pos = npos
      
      if (self.set[oldcell.id].leave) then
         oldcell.id = self.set[oldcell.id].leave
      end
      
      return nil
   else
      local mo = self.map[npos.x][npos.y].obj
      if (mo ~= obj) then
         return mo
      else
         return nil
      end
   end
end

-- move actor across the map
function World:shift(obj, x, y)
   local pos = 
      self:pos(obj.pos.x + x, obj.pos.y + y)
   local cell = self.map[pos.x][pos.y]
   local id = cell.id
   
   if (self.set[cell.id].hit) then
      local k = self.set[id].key
      if (k) then
         if (k == obj:key()) then
            cell.id = self.set[cell.id].hit
         else
            if (obj == self.player) then
               self.message = "I need "..k.."!"
            end
         end
      else
         cell.id = self.set[cell.id].hit
      end
   end
   
   if (self.set[id].move) then
      return self:move(obj, pos.x, pos.y)
   else
      cell.hit = true
      return nil
   end
end

-- insert actor in world
function World:insert(obj, x, y)
   local pos = self:pos(x, y)
   if (self.map[pos.x][pos.y].obj == nil) then
      i = #self.actor + 1
      self.actor[i] = obj
      obj.pos = pos
      self.map[pos.x][pos.y].obj = obj
      return i
   else
      return 0
   end
end

-------------------------------------------------
-- Game update method
function World:update(x, y)
   
   self.message = nil
   
   self.player:command(x, y)
   
   for i, actor in  ipairs(self.actor) do
      local cell = 
         world.map[actor.pos.x][actor.pos.y]
      if (actor.alive) then
         -- move and update actor
         local move = actor:update(self)
         if (move.x == 0 and move.y == 0) then
            if (cell.prop) then
               cell.prop:pickup(actor, world)
            end
         else
            local other = 
               self:shift(actor, move.x, move.y)
            if (other) then
               other:push(actor)
               if (actor == self.player) then
                  self.message = 
                     "I hit "
                     ..other:getName()..
                     "!"
               end
            end
         end
         -- Apply tile effects
         local ncell = 
            self.map[actor.pos.x][actor.pos.y]
         local effect = self.set[ncell.id].effect
         if (effect) then
            for e, t in pairs(effect) do
               actor.effect[e] = t
            end
         end
      else
         if (actor.rot == 0) then
            cell.prop = actor:die(self)
            cell.obj = nil
            self.actor[i] = nil
         else
            actor.rot = actor.rot - 1
         end
      end
   end
   
   self:flush()
   
   self.map[self.player.pos.x][self.player.pos.y].see = true
   
   self:floodview(
      self.player.pos.x, self.player.pos.y, 5
   )
   
   if not self.message and
      self.player.effect.hit 
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
      self.message = hm[love.math.random(#hm)]
   end
   
   
end

function World:flush()
   for x=1, self.width do
      for y=1, self.height do
         local cell = self.map[x][y]
         cell.mem = cell.see
         cell.see = false
         cell.hitdelay = cell.hit
         cell.hit = nil
      end
   end
end

function World:fov(vx, vy, range)
   self.map[vx][vy].see  = true
   for x = -range, range do
      for y = -range, range do
         if ((x*x + y*y) < range*range) then
            local p = self:pos(vx+x, vy+y)
            local cell = self.map[p.x][p.y]
            cell.see =
               self:ray(vx, vy, vx + x, vy + y)
         end
      end
   end
end

function World:floodview(x, y, range, cx, cy)

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
      local pos = self:pos(nx, ny)
      local cell = self.map[pos.x][pos.y]
      local check = not cell.see
      cell.see = true
      if (self.set[cell.id].see and check) then
         self:floodview(x, y, range, nx, ny)
      end
   end

end

function World:path(ox, oy, tx, ty)

   local s4 = {
      {x=1, y=0},
      {x=0, y=1},
      {x=-1, y=0},
      {x=0, y=-1}
   }

   local npath = {x=0, y=0}
   local dist = 
      self.width * self.width +
      self.height * self.height + 10
   for i = 1, #s4 do
      local dir = s4[i]
      local pos = self:pos(dir.x + ox,dir.y + oy)
      local cell = self.map[pos.x][pos.y].id
      if (self.set[cell].move) then
         local dx = math.min(
            math.abs(tx - pos.x), 
            math.abs(tx + self.width - pos.x))
         local dy = math.min(
            math.abs(ty - pos.y), 
            math.abs(ty + self.height - pos.y))
         if (dx*dx + dy*dy < dist) then
            dist = dx*dx + dy*dy
            npath = dir
         end
      end
   end
   
   return npath
end

function World:rpath()
   local dir = {
      {x=0,y=0},
      {x=1,y=0},
      {x=0,y=0},
      {x=-1,y=0},
      {x=0,y=-1}
   }
   return dir[love.math.random(#dir)]
end


function World:ray(x1, y1, x2, y2)
   
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
         
         local pos = self:pos(x1, y1)
         local cell = self.map[pos.x][pos.y]
         --cell.see = true
         if (not self.set[cell.id].see) then
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
         
         local pos = self:pos(x1, y1)
         local cell = self.map[pos.x][pos.y]
         --cell.see = true
         if (not self.set[cell.id].see) then
            return false
         end
      end
   end
   
   return true
end

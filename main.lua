-- A simple Löve2D roguelike game


-------------------------------------------------
--- Class Definitions
-------------------------------------------------

-- Prop class -----------------------------------
Prop = {}
Prop.__index = Prop
setmetatable(Prop, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function Prop:_init(char, hand, name, val, key)
   self.char = char
   self.hand = hand
   self.name = name
   self.val = val or 10
   self.key = key
end

function Prop:pickup(actor, world)
   local cell = 
      world.map[actor.pos.x][actor.pos.y]
   if (actor[self.hand]) then
      cell.prop = actor[self.hand]
   else
      cell.prop = nil
   end
   actor[self.hand] = self
end

function Prop:activate(owner)
   return self.val
end

function Prop:update(owner)
end

-- Actor class --------------------------------
Actor = {}
Actor.__index = Actor
setmetatable(Actor, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function Actor:_init(char, hp, str, name)
   self.name = name
   self.head = char
   self.alive = true
   self.rot = 3
   self.hp = hp
   self.str = str
   self.pos = {x=0, y=0}
   self.effect = {}
end

function Actor:attack()
   local a = self.str
   if (self.right) then
      a = a + self.right:activate(self)
   end
   return a
end

function Actor:push(other)
   self:dmg(other:attack())
end

function Actor:dmg(dmg)
   self.hp = self.hp - dmg
   if (self.hp <= 0) then
      self.alive = false
   end
   self.effect.hit = 1
end

function Actor:update(world)
   for e, val in pairs(self.effect) do
      if (val > 0) then
         self.effect[e] = val - 1
      else
         self.effect[e] = nil
      end
   end
   
   return self:think(world)
end

function Actor:think(world)
   return world:rpath()
   
end

function Actor:die()
   -- Drop a random item if an actor dies
   local items = {}
   if (self.left) then
      table.insert(items, self.left)
   end
   if (self.right) then
      table.insert(items, self.right)
   end
   if (#items > 0) then
      return items[love.math.random(#items)]
   else
      return nil
   end
end

function Actor:key()

   if (self.right) then
      if (self.right.key) then
         return self.right.key
      end
   end
   return nil

end

function Actor:char()
   local l = " "
   local r = " "
   
   if (self.left) then
      l = self.left.char
   end
   
   if (self.right) then
      r = self.right.char
   end
   
   return l..self.head..r
end

function Actor:col()
   local color = {196,0,0}
   if (self.alive) then
      color ={255, 255, 255}
      
      if (self.effect.wet) then
         color = {64, 196, 255}
      end
      
      if (self.effect.hit) then
         color.blink = {255, 32, 32}
      end
      
   end
   return color
end

function Actor:getName()
   if self.alive then
      return self.name
   end
   return "corpse"
end

-- Player class derived from actor --------------
Player = {}
Player.__index = Player
setmetatable(Player,{
   __index = Actor,
   __call = function (cls, ...)
   local self = setmetatable({}, cls)
   self:_init(...)
   return self
   end,
})

function Player:_init(hp, str)
   Actor._init(self, "@", hp, str, "me")
   self.cmd = {x=0, y=0}
end

function Player:command(x, y)
   self.cmd = {x=x, y=y}
end

function Player:think(world)
   return self.cmd
end


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


-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-- Main Program ---------------------------------
-------------------------------------------------
-------------------------------------------------

kerning = 30
linespace = 60

world = {}

view = {x = 1, y = 1, w = 16, h = 14}

off = {x = 0, y = 0 }

range = 4

timer = 0.0

function love.load()
   love.graphics.setNewFont(
      "FiraCode-Regular.ttf", 48
   )
   love.graphics.setColor(255,255,255)
   love.graphics.setBackgroundColor(0,0,0)
   
   world = World(50, 50)
   generate(0)
end

function love.touchpressed(id, x, y, pressure)

   local movex = 0
   local movey = 0

   local w = love.graphics.getWidth() / 4
   local h = love.graphics.getHeight() / 4
   
   if (y < h) then movey = -1 else
      if (y > h * 3) then movey = 1 else
         if (x < w) then movex = -1 end
         if (x > w * 3) then movex = 1 end
      end
   end
   
   timer = love.timer.getTime()
   world:update(movex, movey)
end

function love.touchreleased(id, x, y, pressure)
end

function love.update(dt)
   local pos = world.player.pos
   local dx = math.abs(off.x - pos.x)
   local dy = math.abs(off.y - pos.y)
   if (dx >= range) then
      off.x = pos.x
   end
   if (dy >= range) then
      off.y = pos.y
   end
end

function love.draw()
   
   for x=1, view.w do
      for y=1, view.h do
         
         local wx = x + off.x - (view.w / 2)
         local wy = y + off.y - (view.h / 2)
         local col = world:col(wx, wy)
         
         local t = love.timer.getTime()
         local dt = t - timer
         
         if (col.blink) then
            local v = math.min(dt * 2, 1)
            col = lerprgb(col.blink, col, v)
         elseif (col.sin) then
            local v = math.sin(t*6) * 0.5 + 0.5
            col = lerprgb(col.sin, col, v)
         elseif (col.fsin) then
            local v = math.sin(t*24) * 0.5 + 0.5
            col = lerprgb(col.fsin, col, v)
         end
         
         local cy = (y + view.y) * linespace
         local cx = (x*3+view.x+1)*kerning
         
         local a = 0.1
         love.graphics.setColor(
            col[1]*a, col[2]*a, col[3]*a
         )
         love.graphics.rectangle(
            "fill", 
            cx, cy, 
            kerning * 3, linespace
         )
         
         a=0.2
         love.graphics.setColor(
            col[1]*a, col[2]*a, col[3]*a
         )
         love.graphics.ellipse(
            "fill", 
            cx + kerning * 1.5, 
            cy + linespace * 0.5, 
            kerning * 1.5, linespace * 0.5
         )
         
         a=0.35
         love.graphics.setColor(
            col[1]*a, col[2]*a, col[3]*a
         )
         love.graphics.ellipse(
            "fill", 
            cx + kerning * 1.5, 
            cy + linespace * 0.5, 
            kerning, linespace * 0.333
         )
         
         love.graphics.setColor(col)
         local char = world:char(wx, wy)
         
         for i=0, #char do
            cx = (x * 3 + view.x + i) * kerning
            love.graphics.print(
               char:sub(i,i), cx, cy
            )
         end
      
      end
   end
   
   local pos = world.player.pos
   local cell = world.map[pos.x][pos.y]
   local char = world.set[cell.id].char
   local col = world:mapColor(pos.x, pos.y)
   local name = world.set[cell.id].name
   
   if (cell.prop) then
      name = cell.prop.name
      char = " "..cell.prop.char.." "
      col = {196, 196, 196}
   else
      local c = 
         cell.rand % #world.set[cell.id].char
      char = world.set[cell.id].char[c+1]
   end
   
   local a = 0.5
   love.graphics.setColor(
      col[1]*a, col[2]*a, col[3]*a
   )
   --love.graphics.setColor(col)
   
   love.graphics.rectangle(
            "fill", 
            360, 20,
            kerning * 3, linespace
         )
   love.graphics.setColor(255, 255, 255)
   love.graphics.print(char, 360, 20)
   love.graphics.print(name, 480, 20)
   
   --love.graphics.setColor(255, 255, 255)
   love.graphics.print(
      "HP:"..world.player.hp, 60, 20
   )
   if world.message then
      love.graphics.print(
         world.message,
         60,
         love.graphics.getHeight()-100
      )
   end
end


function lerprgb(a, b, t)
   local r = a[1] + (b[1] - a[1]) * t
   local g = a[2] + (b[2] - a[2]) * t
   local b = a[3] + (b[3] - a[3]) * t
   return {r, g, b}
end

-------------------------------------------------
-- Map Generation -------------------------------
-------------------------------------------------

function generate(seed)

   -- My very hacky level generation
   
   local w = world.width
   local h = world.height
   
   local final = make(w, h, "tree")
   noise(final, 0.25, "treesmall")
   noise(final, 0.1, "stump")
   
   local tmap =
      cellauto(w, h, "tree", "dirt", 3, 0.5)
   
   tmap = apply(final, tmap, "tree")
      
   clear(tmap, 1, 1, 3, "dirt")
   
   local cmap = 
      cellauto(w, h, "cliff", "dirt", 3, 0.35)
   clear(cmap, 1, 1, 8, "dirt")
      
   local gmap = 
      cellauto(w, h, "grass", "dirt", 2, 0.5)
   local bmap =
      cellauto(w, h, "tallgrass", "dirt", 2, 0.4)
   local wmap = 
      cellauto(w, h, "puddle", "dirt", 1, 0.5)
      
   final = make(w, h, "grass")
   noise(final, 0.05, "flower")
   noise(final, 0.01, "stump")
   gmap = apply(final, gmap, "grass")
      
   final = apply(wmap, gmap, "dirt")
   final = apply(final, bmap, "dirt")
   final = apply(final, tmap, "dirt")
   final = apply(final, cmap, "dirt")
   
   final = room(final, -5, -5, 5, 5, "wall", "dirt")

   world:fill(final)

end

function make(w, h, fill)

   local map = {w=w, h=h}

   for x = 1, w do
      map[x] = {}
      for y = 1, h do
         map[x][y] = fill
      end
   end
   
   return map
end

function apply(a, b, alpha)

   local map = make(a.w, a.h, alpha)

   for x=1, a.w do
      for y=1, a.h do
         if (b[x][y] == alpha) then
            map[x][y] = a[x][y]
         else
            map[x][y] = b[x][y]
         end
      end
   end
   return map
end

function cellauto(w, h, a, b, gen, noi)

   local map = make(w, h, b)
   noise(map, noi, a)

   s8 = {{1,0}, {1,1}, {0,1}, {-1,1},
        {-1,0},{-1,-1},{0, -1},{1, -1}}
   
   for i=1, gen do
      prime = map
      map = make(w, h, b)
      for x=1, w do
         for y=1, h do
            local n = 0
            
            for k, s in pairs(s8) do
               local sx = (x + s[1] - 1) % w + 1
               local sy = (y + s[2] - 1) % h + 1
               if (prime[sx][sy] == a) then
                  n = n + 1
               end
            end
            
            if (prime[x][y] == a and n >= 4)
            then
               map[x][y] = a
            end
            if (prime[x][y] == b and n >= 5)
            then
               map[x][y] = a
            end
         end
      end
   end

   return map
end

function clear(m, cx, cy, size, c)

   for x=-size, size do
      for y=-size, size do
         local px = (cx + x - 1) % m.w + 1
         local py = (cy + y - 1) % m.h + 1
         m[px][py] = c
      end
   end
   return m

end

function noise(map, n, a)
   for x=1, map.w do
      for y=1, map.h do
         if (love.math.random() < n) then
            map[x][y] = a
         end
      end
   end
end

function room(map, rx, ry, rw, rh, wall, floor)

   for x = 1, rw do
      for y = 1, rh do
         local px = (rx + x - 1) % map.w
         local py = (ry + y - 1) % map.h
         if (x == 1 or x == rw or 
            y == 1 or y == rh) then
            map[px][py] = wall
         else
            map[px][py] = floor
         end
      end
   end
   local px = (rx + rh - 1) % map.w
   local py = 
      (ry + math.floor(rh / 2 + 0.5) - 1) % map.h
   map[px][py] = "doorclose"
   return map

end

function table.copy(t)
   local u = { }
   for k, v in pairs(t) do
      u[k] = v
   end
   return u
end


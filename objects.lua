objects = {}


-------------------------------------------------
--- Class Definitions
-------------------------------------------------

-- objects.prop class -----------------------------------
objects.prop = {}
objects.prop.__index = objects.prop
setmetatable(objects.prop, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function objects.prop:_init(char, hand, name, val, key)
   self.char = char
   self.hand = hand
   self.name = name
   self.val = val or 10
   self.key = key
end

function objects.prop:pickup(actor, world)
   local cell = 
      world.map[actor.pos.x][actor.pos.y]
   if (actor[self.hand]) then
      cell.prop = actor[self.hand]
   else
      cell.prop = nil
   end
   actor[self.hand] = self
end

function objects.prop:activate(owner)
   return self.val
end

function objects.prop:update(owner)
end

-- objects.actor class --------------------------------
objects.actor = {}
objects.actor.__index = objects.actor
setmetatable(objects.actor, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function objects.actor:_init(char, hp, str, name)
   self.name = name
   self.head = char
   self.alive = true
   self.rot = 3
   self.hp = hp
   self.str = str
   self.pos = {x=0, y=0}
   self.effect = {}
end

function objects.actor:attack()
   local a = self.str
   if (self.right) then
      a = a + self.right:activate(self)
   end
   return a
end

function objects.actor:push(other)
   self:dmg(other:attack())
end

function objects.actor:dmg(dmg)
   self.hp = self.hp - dmg
   if (self.hp <= 0) then
      self.alive = false
   end
   self.effect.hit = 1
end

function objects.actor:update(world)
   self.message = nil
   for e, val in pairs(self.effect) do
      if (val > 0) then
         self.effect[e] = val - 1
      else
         self.effect[e] = nil
      end
   end
   
   return self:think(world)
end

function objects.actor:think(world)
   return world.rpath()
   
end

function objects.actor:die()
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

function objects.actor:key()

   if (self.right) then
      if (self.right.key) then
         return self.right.key
      end
   end
   return nil

end

function objects.actor:char()
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

function objects.actor:col()
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

function objects.actor:getName()
   if self.alive then
      return self.name
   end
   return "corpse"
end

-- objects.player class derived from actor --------------
objects.player = {}
objects.player.__index = objects.player
setmetatable(objects.player,{
   __index = objects.actor,
   __call = function (cls, ...)
   local self = setmetatable({}, cls)
   self:_init(...)
   return self
   end,
})

function objects.player:_init(hp, str)
   objects.actor._init(self, "@", hp, str, "me")
   self.cmd = {x=0, y=0}
end

function objects.player:command(x, y)
   self.cmd = {x=x, y=y}
end

function objects.player:think(world)
   return self.cmd
end

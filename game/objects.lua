local controller = require("game.controller")
local set = require("data.objectset")


local objects = {}

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
   end
})

function objects.prop:_init(id)

   if set.props[id] then
      for k, v in pairs(set.props[id]) do
         self[k] = v
      end
   else
			   self.char = "x"
			   self.hand = "right"
			   self.name = "empty"
			   self.val = 1
			   self.image = 0
			   self.thumb = 0
   end
end

function objects.prop:stats()

   return self.name..": "..self.val

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

-- objects.actor class --------------------------
objects.actor = {}
objects.actor.__index = objects.actor
setmetatable(objects.actor, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function objects.actor:_init(id)

   if set.actors[id] then
      for k, v in pairs(set.actors[id]) do
         self[k] = v
      end
   else
			   self.think = nil
			   self.character = "x"
			   self.img = 3
			   self.name = "null actor"
			   self.hp = 100
			   self.str = 0
   end
   
   self.alive = true
   self.rot = 1
   self.pos = {x=0, y=0}
   self.effect = {}
end

function objects.actor:attack()
   local a = self.str
   if (self.right) then
      self.right:activate(self)
      a = a + self.right.val
   end
   return a
end

function objects.actor:push(other)
   self:dmg(other:attack())
end

function objects.actor:dmg(dmg)
   if self.left then
      dmg = dmg - self.left.val
   end
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
   
   if (self.think) then
      return controller[self.think](self, world)
   else
      return {x=0, y=0}
   end
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


function objects.actor:haskey(key)
   if (self.right) then
      if self.right.key == key then
         return true
      end
   end
   if (self.left) then
      if self.left.key == key then
         return true
      end
   end
   return false
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
   
   return l..self.character..r
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

function objects.actor:sprite()
   local l = 0
   local r = 0
   
   if self.left then
      l = self.left.img or 0
   end
   
   if self.right then
      r = self.right.img or 0
   end
   
   return {r, self.img, l}
end

function objects.actor:getName()
   if self.alive then
      return self.name
   end
   return "corpse"
end

-- player class derived from actor --------------
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
   objects.actor._init(self, "player")
end

return objects

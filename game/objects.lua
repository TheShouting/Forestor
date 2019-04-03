local controller = require("game.controller")
local set = require("data.objectset")
local effects = require("game.effects")


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
			   self.color = {255, 255, 255}
			   self.img = 1
			   self.thumb = 0
   end
end

function objects.prop:color()
   return {255, 255, 255, sin={128, 128, 128}}
end

function objects.prop:col()
   return {255, 255, 255, sin={128, 128, 128}}
end

function objects.prop:sprite()
   return {0, img, 0}
end

function objects.prop:stats()

   return self.name..": "..self.val

end

function objects.prop:onpickup(actor, world)
   return true
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
			   self.img = 1
			   self.name = "null actor"
			   self.hp = 100
			   self.str = 0
   end
   
   self.alive = true
   self.rot = 10
   self.pos = {x=0, y=0}
   self.effect = {}
   self.time = 0
   self.updateTime = 0
end

function objects.actor:pickup(cell)
   local prop = cell.prop
   if prop then
      if not prop.consume then
						   if (self[prop.hand]) then
						      cell.prop = self[prop.hand]
						   else
						      cell.prop = nil
						   end
						   self[prop.hand] = prop
						   
						   self.message = "I have "..prop.name.."!"
			   else
			      self.message = "I take "..prop.name.."!"
			      effects.consume[prop.consume](self,prop)
			      cell.prop = nil
			   end
			else
			   self.message = "There's nothing there."
   end
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
   if key then
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
   return true
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
      for k, v in pairs(self.color) do
         color[k] = v
      end
      
      if (self.effect.wet) then
         color.sin = {64, 196, 255}
      end
      
      if (self.effect.hit) then
         color.blink = {255, 32, 32}
      end
      
   end
   color.time = self.time
   return color
end

function objects.actor:sprite()
   local l = 0
   local r = 0
   
   if self.alive then
   
   if self.left then
      l = self.left.img or 0
   end
   
   if self.right then
      r = self.right.img or 0
   end
   
   return {r, self.img, l}
   
   else
      if self.corpse then
         return {0, self.corpse, 0}
      else
         return {0, self.img, 0}
      end
   end
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
   self.rot = -1
end


function objects.player:update(world)
   if controller.playerinput then
      return objects.actor.update(self, world)
   end
   return nil
end

objects.dummy = {}
objects.dummy.__index = objects.dummy
setmetatable(objects.dummy, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end
})

function objects.dummy:_init(id, action)
   if set.actors[id] then
      for k, v in pairs(set.actors[id]) do
         self[k] = v
      end
   else
      self.color = {255, 255, 255}
			   self.character = "x"
			   self.img = 1
			   self.name = "dummy object"
   end
   
   self.alive = false
   self.rot = -1
   self.pos = {x=0, y=0}
   self.time = 0
   self.updateTime = 0
   
   self.action = action
end

function objects.dummy:push(other)
   -- empty method
   if self.action then
      self.action(other)
   end
   
end

function objects.dummy:col()
   local color = {}
   for k, v in pairs(self.color) do
      color[k] = v
   end
   color.blink = {255, 255, 255}
   color.time = self.time
   return color
end

function objects.dummy:char()
   return " "..self.character.." "
end

function objects.dummy:sprite()
   return {
      self.imgr or 0, 
      self.img, 
      self.imgl or 0
      }
end

-- player class derived from actor --------------
objects.container = {}
objects.container.__index = objects.container
setmetatable(objects.container,{
   __index = objects.dummy,
   __call = function (cls, ...)
   local self = setmetatable({}, cls)
   self:_init(...)
   return self
   end,
})


function objects.container:_init(prop)
   objects.dummy._init(self, "table")
   
   if prop then
      self.hand = prop.hand
      self.prop = prop
   else
      self.hand = "right"
   end

end

function objects.container:col()
   if self.prop then
      return self.prop:color()
   else
      local c = objects.dummy:col(self)
      c.time = self.time
      return c
   end
end

function objects.container:sprite()
   local spr = objects.dummy.sprite(self)
   if self.prop then
      spr[2] = self.prop.thumb
   end
   return spr
end

function objects.container:push(other)
   local prop = other[self.hand]
   other[self.hand] = self.prop
   self.prop = prop
end


return objects

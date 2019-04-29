local set = require("data.objectset")

-- prop class ---------------------------
prop = {}
prop.__index = prop
setmetatable(prop, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end
})


function prop:_init(id)
   if set.props[id] then
      for k, v in pairs(set.props[id]) do
         self[k] = v
      end
   else
			   self.char = "x"
			   self.hand = "right"
			   self.name = "empty"
			   self.color = {255, 255, 255}
			   self.img = 1
			   self.thumb = 0
   end
   
   self.integrity = 100.0
   self.degrade = 1.0
   self.effects = {}
   self.updateeffects = {}
   self.hiteffects = {}
   self.valeffects = {}
end


function prop:getSprite()
   return self.sprite or "blank"
end


function prop:stats()
   local name = self.name
   
   for n, _ in pairs(self.effects) do
      name = n.." "..name
   end
   
   return name.." ("..self.integrity.."%)"
end


function prop:getval(stat)

   local val = 0
   if self[stat] then
      val = self[stat]
      if not self.broken then
			      for _, v in pairs(self.valeffects) do
			         if v[stat] then
			            val = val * v[stat]
			         end
			      end
      end
   end

   return val
end


function prop:usekey(key)
   if self.key == key then
      self:use()
      return true
   end
   return false
end

function prop:use()
   self.integrity = 
      self.integrity - self:getval("degrade")
end

function prop:onpickup(actor)
   if self.pickup then
      self:pickup(actor)
   end
end


function prop:activate(owner)
   return self.val
end


function prop:hitother(owner, other)
   if self.hit then
      self:hit(owner, other)
   end
   
   if not self.broken then
			   for _, effect in pairs(self.hiteffects) do
			      effect(owner, other)
			   end
   end
   
   self:use()
end


function prop:update(owner)
   if not self.broken then
			   for _, effect in 
			      pairs(self.updateeffects) do
			      effect(owner, other)
			   end
   end
end


return prop
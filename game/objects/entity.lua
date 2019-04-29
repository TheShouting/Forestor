local set = require("data.objectset")

-- objects.entity class -------------------------
entity = {}
entity.__index = entity
setmetatable(entity, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})


function entity:_init(id)
   
   if set.actors[id] then
      for k, v in pairs(set.actors[id]) do
         self[k] = v
      end
   else
			   self.character = "x"
			   self.img = 1
			   self.name = "a null actor"
			   self.hp = 100
			   self.str = 0
   end

   self.alive = false
   self.active = false
   self.rot = -1
   self.pos = {x=0, y=0}
   self.status = {}
   self.time = 0
   self.updateTime = 0
   self.anim = {}
   self.animation = {
      pos = {x=0, y=0},
      dir = {x=0, y=0}}
   self.memdmg = 0
end


function entity:pickup(cell)
   
end


function entity:attack(other)
   
end


function entity:push(other)

end


function entity:dmg(dmg)
   
end

function entity:setstatus(s, n)
   
end


function entity:update(world)
   return {x=0, y=0}
end


function entity:die()
   return nil
end


function entity:haskey(key)
   return false
end


function entity:char()
   if self.character then
      return " "..self.character.." "
   end
   return " ? "
end


function entity:col()
   local color = {255, 255, 255}
   if self.color then
      for k, v in pairs(self.color) do
         color[k] = v
      end
   end
   color.blink = {255, 255, 255}
   color.time = self.time
   return color
end


function entity:getSprite()
   return self.sprite or "blank"
end


function entity:getName()
   if self.name then
      return self.name
   end
   return "a null entity"
end

return entity
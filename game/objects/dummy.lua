local entity = require("game.objects.entity")

dummy = {}
dummy.__index = dummy
setmetatable(dummy, {
   __index = entity,
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end
})


function dummy:_init(id, action)
   entity._init(self, id)
   self.action = action
end


function dummy:push(other)
   -- empty method
   if self.action then
      self.action(other)
   end
end

return dummy


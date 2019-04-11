local actor = require("game.objects.actor")

-- player class derived from actor --------------
player = {}
player.__index = player
setmetatable(player,{
   __index = actor,
   __call = function (cls, ...)
   local self = setmetatable({}, cls)
   self:_init(...)
   return self
   end,
})


function player:_init(hp, str)
   actor._init(self, "player")
   self.rot = -1
end


function player:update(world)
   if controller.playerinput then
      return actor.update(self, world)
   end
   return nil
end

return player
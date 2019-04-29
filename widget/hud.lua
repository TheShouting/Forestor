local util = require("util")

local hud = {}

hud.__index = hud
setmetatable(hud,{
   __call = function (cls, ...)
			   local self = setmetatable({}, cls)
			   self:_init(...)
			   return self
   end,
})

function hud:_init(vx, vy, vw, vh, actor)
   self.x = vx
   self.y = vy
   self.w = vw
   self.h = vh
   self.timer = 0.0
   self.actor = actor
   
end

function hud:update(dt)

end


function hud:draw(view_w, view_h)

   love.graphics.setColor(255, 255, 255)
   
   local f = love.graphics.getFont()
   local center = view_w * 0.5
   if self.actor.message then
      local msg = self.actor.message
      local mw = math.floor(f:getWidth(msg) * 0.5)
      love.graphics.print(msg, center-mw, 10)
   end

   local hp = self.actor.hp
   
   love.graphics.print(hp, center, view_h - 18)
   
   
   local right = self.actor.right and self.actor.right:stats() or "[EMPTY]"
   
   love.graphics.print(right, 4, view_h - 18)
   
   local left = self.actor.left and self.actor.left:stats() or "[EMPTY]"
   local x = view_w - (f:getWidth(left) + 4)
   love.graphics.print(left, x, view_h - 18)
   
end

return hud






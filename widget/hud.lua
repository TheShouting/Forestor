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
   
   self.img = love.graphics.newImage(
      "assets/img/heart.png")
   self.img:setFilter( "linear", "nearest" )
   
   self.scale = 2
end

function hud:update(dt)

end


function hud:draw()

   local f = love.graphics.getFont()

   if self.actor.message then
      local msg = self.actor.message
      local mw = f:getWidth(msg) * 0.5
      love.graphics.print(msg, self.w*0.5-mw, 10)
   end


   local hpsize = 36 * self.scale
   local hp = self.actor.hp
   love.graphics.setColor(255,0,0)
   for i = 1, hp do
      local x = i * hpsize + self.x
      local y = self.h - hpsize
      love.graphics.draw(self.img, x, y, 0,
         self.scale, self.scale)
   end
   
   
   if self.actor.memdmg ~= 0 then
      local col = {0,0,0}
      col.fade = {255, 255, 255}
      col.time = self.actor.updateTime
      col = util.processcolor(col, 
         love.timer.getTime())
      love.graphics.setColor(col)
      
      local x = (self.actor.hp + 1) * hpsize
      local y = self.h - hpsize
      love.graphics.print(self.actor.memdmg, 
         x, y)
   end
end

return hud






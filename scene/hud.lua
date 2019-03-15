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


function hud:draw()

   local hp = "Health: "..self.actor.hp
   local f = love.graphics.getFont()
   local w = f:getWidth(hp) * 0.5
   love.graphics.setColor(255, 255, 255)
   love.graphics.print(
      hp, self.x + self.w*0.5 - w, self.y)
      
   if self.actor.right then
      local r = 
         "(R) "..self.actor.right:stats()
      w = f:getWidth(r)
      love.graphics.print(r, 
         self.x + self.w - w, self.y)
   end
   
   if self.actor.left then
      local l = self.actor.left:stats()
      love.graphics.print("(L) "..l, 
         self.x, self.y)
   end
end

return hud






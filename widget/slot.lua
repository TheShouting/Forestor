local slot = {}

slot.__index = slot
setmetatable(slot, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function slot:_init(vx, vy)
   self.x = vx
   self.y = vy
   self.w = 32
   self.h = 32
   self.input = nil
   
   self.img = love.graphics.newImage(
      "assets/img/slot.png")
   self.img:setFilter( "linear", "nearest" )
end


function slot:draw()
   love.graphics.setColor(255,255,255)
   love.graphics.draw(self.img, self.x, self.y, 0, 5, 5)
end


return slot

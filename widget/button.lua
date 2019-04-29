local util = require("util")

local button = {}

button.__index = button
setmetatable(button, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function button:_init(text, press, x, y, w, h,
   ax, ay, aw, ah)
   
   self.x = x or 0
   self.y = y or 0
   self.w = w or 400
   self.h = h or 100
   self.ax = ax or 0
   self.ay = ay or 0
   self.aw = aw or 0
   self.ah = ah or 0
   
   self.text = text
   self.input = press
   self.color = {255, 255, 255}
end


function button:draw(w, h)

   local x, y = util.anchorpoints(self, w, h)

   love.graphics.setColor(self.color)
   love.graphics.rectangle("line", 
      x, y, self.w, self.h)
   
   local f = love.graphics.getFont()
   local fw = f:getWidth(self.text)
   local fh = f:getHeight()
   
   local tx = math.floor(x + self.w * 0.5 - fw * 0.5)
   local ty = y + self.h * 0.5 - fh * 0.5
   
   love.graphics.print(self.text, tx, ty)

end

return button

require("widget")

menu = {}

menu.__index = menu
setmetatable(menu, {
   __index = widget.base,
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function menu:_init(text, ...)
   widget.base._init(self, ...)
   self.text = text
   self.color = {255, 255, 255}
end


function menu:draw()

   love.graphics.setColor(self.color)
   love.graphics.rectangle("line", 
      self.x, self.y, self.w, self.h)
   
   local f = love.graphics.getFont()
   local fw = f:getWidth(self.text)
   local fh = f:getHeight()
   
   local tx = self.x + self.w * 0.5 - fw * 0.5
   local ty = self.y + self.h * 0.5 - fh * 0.5
   
   love.graphics.print(self.text, tx, ty)

end


local widget = {}

widget.__index = widget
setmetatable(widget, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function widget:_init(vx, vy, vw, vh, i)
   self.x = vx
   self.y = vy
   self.w = vw
   self.h = vh
   self.input = i
end



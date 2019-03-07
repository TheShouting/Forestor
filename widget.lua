widget = {}

widget.base = {}
widget.base.__index = widget.base
setmetatable(widget.base, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function widget.base:_init(vx, vy, vw, vh, a)
   self.x = vx
   self.y = vy
   self.w = vw
   self.h = vh
   self.act = a
   self.events = {}
end



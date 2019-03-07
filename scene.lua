scene = {}

scene.__index = scene
setmetatable(scene, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function scene:_init(...)
   self.widgets = {}
   self.count = select("#",...)
   for i=1, select("#",...) do
      self.widgets[i] = select(i,...)
      self.widgets[i].owner = self
   end
   
   self.sceneControl = nil
   
   --self.borders = {255, 0, 0}
end

function scene:enter() end

function scene:exit() end

function scene:input(x, y, time)

   for i, w in ipairs(self.widgets) do
      if (x > w.x and x < w.x + w.w) then
         if (y > w.y and y < w.y + w.h) then
            if w.act then
               w:act(time)
               return
            end
         end
      end
   end
   
end

function scene:update(dt)
   local out = self.sceneControl
   self.sceneControl = nil
   return out
end

function scene:draw()
end




local scene = {}

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
   
   self.newscene = self
   
end

function scene:input(x, y)

   for i, w in ipairs(self.widgets) do
      if w.input then
         if (x > w.x and x < w.x + w.w) then
            if (y > w.y and y < w.y + w.h) then
               w.input(self)
               return
            end
         end
      end
   end
   
end

function scene:updateScene(dt)
   
   if self.update then
      self:update(dt)
   end
   
   for i, w in ipairs(self.widgets) do
      if w.update then
         w.update(self, dt)
      end
   end

   return self.newscene
end

function scene:drawScene()

   if self.draw then
      self:draw()
   end
   
   for i, w in ipairs(self.widgets) do
      if w.draw then
         w:draw()
      end
   end
   
   if self.debug then
      love.graphics.setColor(self.debug)
      for i, w in pairs(self.widgets) do
         love.graphics.rectangle("line", 
            w.x, w.y, w.w, w.h)
      end
   end
   
end

return scene


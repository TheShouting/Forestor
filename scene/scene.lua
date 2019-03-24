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
   
   self.drawpress = true
   self.presstime = 0
   self.pressarea = {0, 0, 0, 0}
   self.presshit = {0, 0}
   
end

function scene:input(x, y)

   for i, w in ipairs(self.widgets) do
      if w.input then
         if (x > w.x and x < w.x + w.w) then
            if (y > w.y and y < w.y + w.h) then
               w.input(self)
               self.presstime =
                  love.timer.getTime()
               self.pressarea = {
                  w.x, w.y, w.w, w.h}
               self.presshit = {x, y}
               return
            end
         end
      end
   end
   
end

function scene:goprevious()
   self.newscene = self.previousscene
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
   
   if self.drawpress then
      local alpha = 24
			   local dt =
			      love.timer.getTime() - self.presstime
			   local a = alpha - math.min(dt*2, 1) * alpha
			   love.graphics.setColor(255, 255, 255, a)
			   love.graphics.rectangle("fill", 
			      self.pressarea[1], self.pressarea[2], 
			     self.pressarea[3], self.pressarea[4])
			   love.graphics.circle("fill", 
			      self.presshit[1], self.presshit[2], 80)
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


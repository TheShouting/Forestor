local scene = require("scene.scene")
local widget = require("widget.widget")

local levelgen = require("gen.levelgen")
local tools = require("gen.tools")

local util = require("util")

local testscene = {}

testscene.__index = testscene
setmetatable(testscene, {
   __index = scene,
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function testscene:_init()

   scene._init(self)
     
     
   self.min = 64
   self.max = 128
   
   local border = 16
   
   self.x = border
   self.y = border
   self.w = self.width - border * 2
   self.h = self.height - border * 2
   
   self:addwidget(
      {x = self.x, y = self.y, 
      w = self.w, h = self.h,
      input = self.newlevel})
   
   self:newlevel()
end

function testscene:draw()

   love.graphics.setColor(64, 64, 64)
   love.graphics.rectangle("line", 
      self.x, self.y, self.w, self.h)
   love.graphics.line(0, 540, 1920, 540)
   love.graphics.line(960, 0, 960, 1080)

   for ox = -1, 1 do
      for oy = -1, 1 do
         
         local px = 
            self.x + self.w * ox - self.w * 0.5
         local py = 
            self.y + self.h * oy - self.h * 0.5

         for i, node in ipairs(self.level) do
         
            local x = node.x + px
            local y = node.y + py
         
            love.graphics.setColor(32, 32, 32)
            love.graphics.circle(
               "line", x, y, self.min/2)
            love.graphics.setColor(255, 255, 255)
            love.graphics.circle("fill",x,y,4)
            
            love.graphics.print(i, x+5, y+5)
            
            for _, n in ipairs(node.neighbors) do
                  
                  if n > i then
               
               
                  local nx = self.level[n].x + px
                  local ny = self.level[n].y + py
                  
                  if math.abs(x - nx) > 
                     math.abs(x - nx - self.w) 
                     then
                     nx = nx + self.w
                  elseif math.abs(x - nx) >
                     math.abs(x - nx + self.w) 
                     then
                     nx = nx - self.w
                  end
                  
                  if math.abs(y - ny) > 
                     math.abs(y - ny - self.h) 
                     then
                     ny = ny + self.h
                  elseif math.abs(y - ny) >
                     math.abs(y - ny + self.h) 
                     then
                     ny = ny - self.h
                  end
                  
                  
                  love.graphics.line(x,y,nx,ny)
                  
                  end
            end
         end
         
         love.graphics.setColor(255, 0, 0)
         local ex = self.endpoint.x + px
         local ey = self.endpoint.y + py
         love.graphics.circle("line",ex,ey, 10)
         love.graphics.print(self.dist, 
            ex + 5, ey - 21)
            
         love.graphics.setColor(0, 255, 0)
         love.graphics.circle("line",px,py,8)
         
         love.graphics.setColor(0, 0, 255)
         local lx = self.last.x + px
         local ly = self.last.y + py
         love.graphics.circle("line",lx,ly,10)
         
         
      end
   end

end

function testscene:newlevel()

   local seed = love.timer.getTime()
   local rng = love.math.newRandomGenerator(seed)
   self.level =
      --levelgen.makeLevel(self.w,self.h,8,8,rng)
      levelgen.brids(self.w, self.h, 
      20, 100, self.min, self.max, rng)
   
   
   local ep, d = levelgen.getFarthest(self.level)
   
   self.dist = d
   self.endpoint = self.level[ep]
   self.last = self.level[#self.level]

end

return testscene
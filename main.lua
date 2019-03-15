-- A simple Löve2D roguelike game


--require("objects")
--require("controller")
require("util")
local gamescene = require("scene.gamescene")


-------------------------------------------------
-- Main Program ---------------------------------
-------------------------------------------------

local app = nil

function love.load()
   love.graphics.setNewFont(
      "FiraCode-Regular.ttf", 48)
   love.graphics.setColor(255,255,255)
   love.graphics.setBackgroundColor(0,0,0)
   
   app = gamescene()
end

function love.touchpressed(id, x, y, pressure)
   app:input(x, y, love.timer.getTime())
end

function love.touchreleased(id, x, y, pressure)
end

function love.update(dt)

   app = app:updateScene(dt)
   if not app then
      love.event.quit()
   end
   
end

function love.draw()

   app:drawScene()
   
   if app.debug then
      love.graphics.setColor(app.debug)
      for i, w in pairs(app.widgets) do
         love.graphics.rectangle("line", 
            w.x, w.y, w.w, w.h)
      end
   end
end







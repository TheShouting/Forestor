-- A simple Löve2D roguelike game

require("util")
local scene = require("scene.menuscene")
--local scene = require("scene.gamescene")

-------------------------------------------------
-- Main Program ---------------------------------
-------------------------------------------------

local app = nil

function love.load()
   love.graphics.setNewFont(
      "assets/font/FiraCode-Regular.ttf", 48)
   love.graphics.setColor(255,255,255)
   love.graphics.setBackgroundColor(0,0,0)
   
   app = scene()
end

function love.touchpressed(id, x, y, pressure)
   app:input(x, y)
end

function love.touchreleased(id, x, y, pressure)
end

function love.update(dt)

   local nextapp = app:updateScene(dt)
   if nextapp then
      app = nextapp
   else
      love.event.quit()
   end
   
end

function love.draw()

   app:drawScene()
   
end


function love.quit()
   if app.quit then
      app:quit()
   end
end





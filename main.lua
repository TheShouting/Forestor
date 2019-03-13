-- A simple Löve2D roguelike game

require("world")
require("objects")
require("controller")
require("util")
require("gamescene")

mapgen = require("mapgen")


-------------------------------------------------
-- Main Program ---------------------------------
-------------------------------------------------

local app = {}

function love.load()
   love.graphics.setNewFont(
      "FiraCode-Regular.ttf", 48)
   love.graphics.setColor(255,255,255)
   love.graphics.setBackgroundColor(0,0,0)
   
   world.new(150, 150)
   local map = mapgen.generate(150, 150, 0)
   world.fill(map)
   
   app = {game = gamescene()}
   currentscene = "game"
end

function love.touchpressed(id, x, y, pressure)
   local s = app[currentscene]
   s:input(x, y, love.timer.getTime())
end

function love.touchreleased(id, x, y, pressure)
end

function love.update(dt)

   local s = app[currentscene]
   local opt = s:update(dt)
   if opt then
      if opt == "exit" then
         love.event.quit()
      else
         currentscene = opt
      end
   end
   
end

function love.draw()

   local s = app[currentscene]

   love.graphics.setColor(255, 255, 255)
   s:draw()
   
   if s.debug then
      love.graphics.setColor(s.debug)
      for i, w in pairs(s.widgets) do
         love.graphics.rectangle("line", 
            w.x, w.y, w.w, w.h)
      end
   end
end







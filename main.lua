-- A simple Löve2D roguelike game

require("world")
require("mapgen")
require("objects")


-------------------------------------------------
-- Main Program ---------------------------------
-------------------------------------------------

kerning = 30
linespace = 60

view = {x = 1, y = 1, w = 16, h = 14}

off = {x = 0, y = 0 }

range = 4

timer = 0.0

function love.load()
   love.graphics.setNewFont(
      "FiraCode-Regular.ttf", 48
   )
   love.graphics.setColor(255,255,255)
   love.graphics.setBackgroundColor(0,0,0)
   
   world.new(150, 150)
   local map = mapgen.generate(150, 150, 0)
   world.fill(map)
end

function love.touchpressed(id, x, y, pressure)

   local movex = 0
   local movey = 0

   local w = love.graphics.getWidth() / 4
   local h = love.graphics.getHeight() / 4
   
   if (y < h) then movey = -1 else
      if (y > h * 3) then movey = 1 else
         if (x < w) then movex = -1 end
         if (x > w * 3) then movex = 1 end
      end
   end
   
   timer = love.timer.getTime()
   world.update(movex, movey)
end

function love.touchreleased(id, x, y, pressure)
end

function love.update(dt)
   local pos = world.player.pos
   local dx = math.abs(off.x - pos.x)
   local dy = math.abs(off.y - pos.y)
   if (dx >= range) then
      off.x = pos.x
   end
   if (dy >= range) then
      off.y = pos.y
   end
end

function love.draw()

   local msg = {}

   local t = love.timer.getTime()
   local dt = t - timer
   
   for x=1, view.w do
      for y=1, view.h do
         
         local wx = x + off.x - (view.w / 2)
         local wy = y + off.y - (view.h / 2)
         local col = world.col(wx, wy)
         
         if (col.blink) then
            local v = math.min(dt * 2, 1)
            col = lerprgb(col.blink, col, v)
         elseif (col.sin) then
            local v = math.sin(t*6) * 0.5 + 0.5
            col = lerprgb(col.sin, col, v)
         elseif (col.fsin) then
            local v = math.sin(t*24) * 0.5 + 0.5
            col = lerprgb(col.fsin, col, v)
         end
         
         local char = world.char(wx, wy)
         
         local cy = (y + view.y) * linespace
         local cx = (x*3+view.x+1)*kerning
         
         drawtile(
            cx, cy,
            char, col,
            kerning, linespace
         )
         
         local obj = world.getActor(wx, wy)
         
         if obj then
            if obj.message then
               msg[#msg+1] =
                  {msg=obj.message, x=cx, y=cy}
            end
         end
      
      end
   end
   
   for k, v in ipairs(msg) do
      drawmessage(v.msg, 
         v.x+kerning*3, 
         v.y-4, 
         {255,255,255},
         10, dt)
   end
   
   local pos = world.player.pos
   local cell = world.map[pos.x][pos.y]
   local char = world.set[cell.id].char
   local col = world.mapColor(pos.x, pos.y)
   local name = world.set[cell.id].name
   
   if (cell.prop) then
      name = cell.prop.name
      char = " "..cell.prop.char.." "
      col = {196, 196, 196}
   else
      local c = 
         cell.rand % #world.set[cell.id].char
      char = world.set[cell.id].char[c+1]
   end
   
   local a = 0.5
   love.graphics.setColor(
      col[1]*a, col[2]*a, col[3]*a
   )
   --love.graphics.setColor(col)
   
   love.graphics.rectangle(
            "fill", 
            360, 20,
            kerning * 3, linespace
         )
   love.graphics.setColor(255, 255, 255)
   love.graphics.print(char, 360, 20)
   love.graphics.print(name, 480, 20)
   
   love.graphics.print(
      "HP:"..world.player.hp, 60, 20
   )
   if world.player.message then
      love.graphics.print(
         world.player.message,
         60, love.graphics.getHeight()-100
      )
   end
end


function lerprgb(a, b, t)
   local r = a[1] + (b[1] - a[1]) * t
   local g = a[2] + (b[2] - a[2]) * t
   local b = a[3] + (b[3] - a[3]) * t
   return {r, g, b}
end


function drawmessage(msg, x, y, c, pad, dt)

   local scroll = math.min(dt * 4, 1)
   nmsg = string.sub(msg, 1, 
      math.floor(#msg * scroll) - #msg - 1)

   local a = math.min(dt * 0.33, 1)
   local col = {c[1], c[2], c[3], 255 - 255*a}
   local tpad = pad*2
   local f = love.graphics.getFont()
   local w = f:getWidth(msg) * scroll
   local h = f:getHeight()
   love.graphics.setColor(0,0,0, col[4])
   love.graphics.rectangle(
      "fill", x, y, w + tpad, h + tpad)
   love.graphics.setColor(col)
   love.graphics.rectangle(
      "line", x, y, w + tpad, h + tpad)
   love.graphics.print(nmsg, x+pad, y+pad)
end


function drawtile(x, y, char, col, k, l)
   local a = 0.1
   love.graphics.setColor(
      col[1]*a, col[2]*a, col[3]*a
      )
   love.graphics.rectangle("fill", x, y, k*3, l)
         
   a=0.2
   love.graphics.setColor(
     col[1]*a, col[2]*a, col[3]*a
   )
   love.graphics.ellipse(
      "fill", x+k*1.5, y+l*0.5, k*1.5, l*0.5
   )
         
   a=0.35
   love.graphics.setColor(
      col[1]*a, col[2]*a, col[3]*a
   )
   love.graphics.ellipse(
      "fill", x+k*1.5, y+l*0.5, k, l*0.333
   )
         
   love.graphics.setColor(col)
         
   for i=1, #char do
      cx = x + k*(i-1)
      love.graphics.print(char:sub(i,i), cx, y)
   end
end





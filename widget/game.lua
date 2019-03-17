require("util")

local tileset = require("assets.tileset")

local game = {}

game.__index = game
setmetatable(game,{
   __call = function (cls, ...)
			   local self = setmetatable({}, cls)
			   self:_init(...)
			   return self
   end,
})

function game:_init(vx, vy, vw, vh, world)
   self.x = vx
   self.y = vy
   self.w = vw
   self.h = vh
			--self.tilew = 30
			--self.tileh = 60
			
			self.off = {x = 0, y = 0 }
			self.range = 4
			self.world = world
			self.timer = 0
			
			self.tilew = 16
			self.tileh = 32
			self.scale = 2
			
			self.ground = tileset:load(
			   "ground", self.tilew, self.tileh)
			self.objects = tileset:load(
			   "objects", self.tilew, self.tileh)
end

function game:update(dt)

   local pos = self.world.player.pos
   local dx = math.abs(self.off.x - pos.x)
   local dy = math.abs(self.off.y - pos.y)
   if (dx >= self.range) then
      self.off.x = pos.x
   end
   if (dy >= self.range) then
      self.off.y = pos.y
   end

end

function game:draw()

   local dt = self.timer - self.world.timer
   
   local tw = self.tilew * 3 * self.scale
   local th = self.tileh * self.scale
   
   local vw =
      math.floor((self.w / tw) * 0.5)
   local vh = 
      math.floor((self.h / th) * 0.5)
   local bx = 
      (self.w - vw*2*tw) * 0.5
   local by = 
      (self.h - vh*2*th) * 0.5
   
   for x=1, vw*2 do
      for y=1, vh*2 do
         
         local wx = x + self.off.x - vw
         local wy = y + self.off.y - vh
         local col = self.world.col(wx, wy)
         
         col = util.processcolor(
            col, dt, self.timer, wx * wy)
         
         --local char = self.world.char(wx, wy)
         
         local cx = x * tw + self.x - tw + bx
         local cy = y * th + self.y - th + by
        
         --util.drawtile(
         --   cx, cy, char, col, tw / 3, th, true)
         
         love.graphics.setColor(col)
         
         local t = self.world.objImage(wx, wy)
         local set = self.objects
         
         if not t then
            t = self.world.image(wx, wy)
            set = self.ground
         end
         
         for i = 1, 3 do
            if t[i] > 0 then
               love.graphics.draw(
                  set.img, 
                  set.tile[t[i]],
                  cx + (i - 1)* (tw / 3), cy, 0, 
                  self.scale, self.scale, 0, 0)
            end
         end
         
      end
   end
   
end

return game

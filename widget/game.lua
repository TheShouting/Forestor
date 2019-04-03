local util = require("util")

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
			
			self.canvas = love.graphics.newCanvas(vw, vh)
			
			self.off = {x = 1, y = 1 }
			self.range = 4
			self.world = world
			
			self.tilew = 8
			self.tileh = 16
			self.scale = 4
			
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

   love.graphics.setCanvas(self.canvas)
   love.graphics.clear(0, 0, 0)

   local actors = {}

   local timer = love.timer.getTime()
   
   local tw = self.tilew * 3 * self.scale
   local th = self.tileh * self.scale
   
   local vw = math.floor((self.w / tw) * 0.5) + 1
   local vh = math.floor((self.h / th) * 0.5) + 1
   
   for x=1, vw*2 do
      for y=1, vh*2 do
         
         local wx = self.off.x + x - vw
         local wy = self.off.y + y - vh
         --local char = self.world.char(wx, wy)
         
         local cx = (x - vw) * tw + self.w * 0.5
         local cy = (y - vh) * th + self.h * 0.5
         
         local o = wx * wy *
            (self.world.random(wx, wy) / 100)
         
         local t = self.world.image(wx, wy)
         
         local col = self.world.mapColor(wx, wy)
         col = util.processcolor(col, timer, o)
         
         love.graphics.setColor(col)
         for i = 1, 3 do
            if t[i] > 0 then
               love.graphics.draw(
                  self.ground.img, 
                  self.ground.tile[t[i]],
                  cx + (i - 1)* (tw / 3), cy, 0, 
                  self.scale, self.scale, 0, 0)
            end
         end
         
         t = self.world.propImage(wx, wy)
         
         if t then
			         col = self.world.objColor(wx, wy)
			         col = util.processcolor(col,timer,o)
			         love.graphics.setColor(col)
         
			         for i = 1, 3 do
			            if t[i] > 0 then
			               love.graphics.draw(
			                  self.objects.img, 
			                  self.objects.tile[t[i]],
			                  cx + (i - 1)* (tw / 3), cy, 
			                  0, 
			                  self.scale, self.scale, 
			                  0, 0)
			            end
			         end
         end
         
         util.drawglow(col, cx, cy, tw, th)
         
         if self.world.visible(wx, wy) then
			         local a = self.world.getActor(wx, wy)
			         if a then
			            actors[#actors+1] = a
			         end
         end
      end
   end
   
   -- Draw all visible actors on top of map
   for _, a in pairs(actors) do
      local ax = a.pos.x - self.off.x
      local ay = a.pos.y - self.off.y
      
      if a.anim then
         ax = a.anim.pos.x - self.off.x
         ay = a.anim.pos.y - self.off.y
         local bx = ax + a.anim.dir.x
         local by = ay + a.anim.dir.y
						   local dt = timer - a.updateTime
								 local v = math.min(dt * 6, 1)
									local j = math.sin(v * 3.142) * 0.33
									
         if a.anim.pos.x == a.pos.x and
            a.anim.pos.y == a.pos.y then
            v = math.sin(v * 3.142) * 0.25
            j = 0
									end
									
									ax = ax + (bx - ax) * v
								 ay = ay + (by - ay) * v - j
				  end
				  
				  ax = (ax) * tw + self.w * 0.5
      ay = (ay) * th + self.h * 0.5
      
      local o = a.pos.x * a.pos.y *
         self.world.random(a.pos.x, a.pos.y)*0.01
      local ac = 
         util.processcolor(a:col(), timer, o)
      love.graphics.setColor(ac)
			      
						local img = a:sprite()
						for i=1, 3 do
						   if img[i] > 0 then
									   love.graphics.draw(
									      self.objects.img, 
									      self.objects.tile[img[i]],
									      ax + (i - 1) * (tw / 3), ay, 0, 
									      self.scale, self.scale, 0, 0)
									end
					 end
   end
   
   -- Draw canvas
   love.graphics.setCanvas()
   love.graphics.setColor(255,255,255)
   love.graphics.draw(self.canvas,self.x,self.y)
   
end

return game

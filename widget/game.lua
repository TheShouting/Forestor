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
			self.scale = 3
			
			self.ground = tileset:load(
			   "ground", self.tilew, self.tileh)
			self.objects = tileset:load(
			   "objects", self.tilew, self.tileh)
			   
end

function game:update(dt)

   local offx = self.off.x
   local offy = self.off.y
   local ww = self.world.width
   local wh = self.world.height
   local pos = self.world.player.pos
   
   local dx = math.min(math.abs(pos.x - offx),
      math.abs(pos.x - offx - ww))
   local dy = math.min(math.abs(pos.y - offy),
      math.abs(pos.y - offy - wh))
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
   
   
   local px = (self.off.x - vw) * tw
   local py = (self.off.y - vh) * th
   love.graphics.setColor(0, 40, 0)
   love.graphics.ellipse(
			   "fill", px, py, px * 0.5, py * 0.5)
			love.graphics.setColor(255, 255, 255, 64)
   love.graphics.ellipse(
			   "fill", px, py, px * 0.1, py * 0.1)
   
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
         
        -- util.drawglow(col, cx, cy, tw, th)
         
         -- collate
         if self.world.visible(wx, wy) then
			         local a = self.world.getActor(wx, wy)
			         if a then
			            actors[#actors+1] = a
			         end
			      else
			         love.graphics.setColor(0,0,0)
			         love.graphics.rectangle(
			            "fill", cx, cy, tw, th)
         end
      end
   end
   
   -- Draw all visible actors on top of map
   for _, a in pairs(actors) do
      local ax = a.pos.x
      local ay = a.pos.y
      local bx = ax
      local by = ay
         
      if #a.animation > 0 then
			      local ftime = 1 / 6
			      local dt = timer - a.updateTime
			      local f = math.floor(dt / ftime)
			      f = math.min(f, #a.animation - 1)
			      dt = dt - f * ftime
			 
         local anim = a.animation[f + 1]
         
			      ax = anim.pos.x
			      ay = anim.pos.y
			      bx = ax + anim.dir.x
			      by = ay + anim.dir.y
									   
								 if anim.lerp then
											 local v = math.min(dt / ftime, 1)
												local j = 0
															
						      if anim.lerp == "bump" then
						         v = math.sin(v * 3.142) * 0.25
						      elseif anim.lerp == "step" then
						         j = math.sin(v * 3.142) * 0.33
												end
															
												ax = ax + (bx - ax) * v
											 ay = ay + (by - ay) * v - j
									else
										  ax = bx
										  ay = by
								 end
					 end
				  
				  -- eventually, have the position of the
				  -- animated sprite cause the map glow
				  --[[
				  local tx = math.floor(bx)
				  local ty = math.floor(by)
				  local tile = self.world.image(tx, ty)
				  --]]
				  
				  local worldw = self.world.width
				  local worldh = self.world.height
				  
				  ax = ax - self.off.x
				  ay = ay - self.off.y
				  
				  ax = (ax+worldw*0.5) % worldw - worldw*0.5
				  ay = (ay+worldh*0.5) % worldh - worldh*0.5
				  
				  ax = ax * tw + self.w * 0.5
      ay = ay * th + self.h * 0.5
      
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

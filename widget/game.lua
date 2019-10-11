local util = require("util")
local imagehandler = require("assets.imagehandler")
local color = require("assets.color")
local tileset = require("data.tileset")
local spriteset = require("data.spriteset")

local game = {}

game.__index = game
setmetatable(game,{
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function game:_init(world)
	self.off = {x = 1, y = 1 }
	self.range = 4.5
	self.world = world
	   
	self.handler = imagehandler(tileset, spriteset)
			   
end

function game:update(dt)

	local offx = self.off.x
	local offy = self.off.y
	local ww = self.world.width
	local wh = self.world.height
	local pos = self.world.player.pos
	
	local dx = math.min(math.abs(pos.x - offx), math.abs(pos.x - offx - ww))
	local dy = math.min(math.abs(pos.y - offy), math.abs(pos.y - offy - wh))
	
	if (dx >= self.range) then
		self.off.x = pos.x
	end
	if (dy >= self.range) then
		self.off.y = pos.y
	end

end

function game:draw(view_w, view_h)

	local actors = {}
	
	local timer = love.timer.getTime()
	
	local tw = tileset.width
	local th = tileset.height
	
	local vw = math.floor((view_w / tw) * 0.5) + 1
	local vh = math.floor((view_h / th) * 0.5) + 1
	
	
	local worldw = self.world.width
	local worldh = self.world.height
	
	local px = self.world.player.pos.x - self.off.x
	local py = self.world.player.pos.y - self.off.y
	
	px = (px + worldw * 0.5) % worldw - worldw * 0.5
	py = (py + worldh * 0.5) % worldh - worldh * 0.5
	
	px = px * tw + view_w * 0.5
	py = py * th + view_h * 0.5
	
	love.graphics.setColor(45, 30, 20)
	love.graphics.circle("fill", px, py - th * 0.5, tw * 4)

   
	for x = 1, vw * 2 do
		for y = 1, vh * 2 do
		
			local wx = self.off.x + x - vw
			local wy = self.off.y + y - vh
			
			local cx = (x - vw) * tw + view_w * 0.5
			local cy = (y - vh) * th + view_h * 0.5
			
			local r = wx * wy * (self.world.random(wx, wy) / 100)
			
			local state, ctime = self.world.getState(wx, wy)
			
			local tile = tileset[self.world.getTile(wx, wy)]
			
			if not tile then
				tile = tileset["blank"]
			end
			
			if state ~= "hidden" then
			
				col = color:getColor(tile.color)
				
				col.time = ctime
				if state == "hit" then
					col.blink = {255,255,255}
				elseif state == "walk" then
					col.blink = {255,255, 255}
				end
				
				col = color.processcolor(col, timer, r)
				love.graphics.setColor(col)
				
				local bitmask = self.world.getbitmask(wx, wy)
				
				self.handler:drawtile(cx, cy, tile, bitmask, r, 1)
				local prop = self.world.propSprite(wx, wy)
				if prop then
					love.graphics.setColor(0,0,0)
					love.graphics.circle("fill", cx, cy - th * 0.5, tw * 0.5)
					love.graphics.setColor(255,255,255)
					
					local sprite = spriteset[prop]
					self.handler:drawsprite(cx, cy, sprite, "ground")
				end
			
			-- collate actors
				local a = self.world.getActor(wx, wy)
				if a then
					actors[#actors + 1] = a
				end
			else
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("fill", cx - tw * 0.5, cy - th, tw, th)
			end
		end
	end
	
	-- Draw all visible actors on top of map
	for _, a in pairs(actors) do
		self:drawActor(a, th, tw, view_w, view_h)
	end
   
end

function game:drawActor(a, th, tw, vw, vh)

	local timer = love.timer.getTime()
	
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
	
	local worldw = self.world.width
	local worldh = self.world.height
	
	ax = ax - self.off.x
	ay = ay - self.off.y
	
	ax = (ax + worldw * 0.5) % worldw - worldw * 0.5
	ay = (ay + worldh * 0.5) % worldh - worldh * 0.5
	
	ax = ax * tw + vw * 0.5
	ay = ay * th + vh * 0.5
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", ax, ay - th * 0.5, tw * 0.5)
  
	local o = a.pos.x * a.pos.y * self.world.random(a.pos.x, a.pos.y)*0.01
	local ac = color.processcolor(a:col(), timer, o)
	love.graphics.setColor(ac)
	
	local sprite = spriteset[a:getSprite()]
	if sprite then
		self.handler:drawsprite(ax, ay, sprite, "idle", 1)
	else
		love.graphics.circle("fill", ax, ay - th * 0.5, tw * 0.25)
	end

	if a.right then
		local prop = spriteset[a.right:getSprite()]
		self.handler:drawsprite(ax + tw / 2, ay, prop, "hand")
	end
   
	if a.left then
		local prop = spriteset[a.left:getSprite()]
		self.handler:drawsprite(ax - tw / 2, ay, prop, "hand")
	end
end

return game

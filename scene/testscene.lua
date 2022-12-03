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
end


function testscene:start()
	
	self.min = 32
	self.max = 128

	local border = 16

	self.x = border
	self.y = border
	self.w = self.width - border * 2
	self.h = self.height - border * 2

	self:addwidget( {x = self.x, y = self.y, w = self.w, h = self.h, input = self.newlevel, key="space"})
	self:addwidget( {x = self.x, y = 0, w = self.w + border * 2, h = border, input = self.toggledebug, key="return"})

	self:newlevel()
	
end


function testscene:draw()

	love.graphics.setColor(0.25, 0, 0)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	love.graphics.line(0, 540, 1920, 540)
	love.graphics.line(960, 0, 960, 1080)

	for ox = -1, 1 do
		for oy = -1, 1 do

			local px = self.x + self.w * ox - self.w * 0.5
			local py = self.y + self.h * oy - self.h * 0.5

			for i, node in ipairs(self.level) do

				local x = node.x + px
				local y = node.y + py
				
				-- Draw Doors
				love.graphics.setColor(0.5, 0.5, 0.5)
				for _, door in ipairs(self.level[i].doors) do
					--love.graphics.rectangle("fill", x, y, 10, 10)
					local door_x = door.x + px
					local door_y = door.y + py
					if door.destination > i then
						for _ ,d2 in ipairs(self.level[door.destination].doors) do
							if d2.destination == i then
								
								local nx = d2.x + px
								local ny = d2.y + py
								
								if math.abs(door_x - nx) > math.abs(door_x - nx - self.w) then
									nx = nx + self.w
								elseif math.abs(door_x - nx) > math.abs(door_x - nx + self.w) then
									nx = nx - self.w
								end
			
								if math.abs(door_y - ny) > math.abs(door_y - ny - self.h) then
									ny = ny + self.h
								elseif math.abs(door_y - ny) > math.abs(door_y - ny + self.h) then
									ny = ny - self.h
								end

								love.graphics.line(door_x, door_y, nx, ny)
								break
							end
						end
					end
					love.graphics.rectangle("fill", door_x - 2, door_y - 2, 4, 4)
				end

				love.graphics.setColor(0.125, 0.125, 0.125)
				--love.graphics.circle("line", x, y, self.min/2)
				love.graphics.rectangle("line", x - node.size / 2, y - node.size / 2, node.size, node.size)
				love.graphics.setColor(1, 1, 1)
				love.graphics.circle("fill",x,y,4)
				love.graphics.print(i, x+5, y+5)

				-- Draw Doors
				for _, n in ipairs(node.neighbors) do
					if n > i then
						local nx = self.level[n].x + px
						local ny = self.level[n].y + py

						if math.abs(x - nx) > math.abs(x - nx - self.w) then
							nx = nx + self.w
						elseif math.abs(x - nx) > math.abs(x - nx + self.w) then
							nx = nx - self.w
						end

						if math.abs(y - ny) > math.abs(y - ny - self.h) then
							ny = ny + self.h
						elseif math.abs(y - ny) > math.abs(y - ny + self.h) then
							ny = ny - self.h
						end

						love.graphics.line(x,y,nx,ny)
					end
				end
				
			end

			love.graphics.setColor(1, 0, 0)
			local ex = self.endpoint.x + px
			local ey = self.endpoint.y + py
			love.graphics.circle("line", ex, ey, 10)
			love.graphics.print(self.dist, ex + 5, ey - 21)

			love.graphics.setColor(0, 1, 0)
			love.graphics.circle("line",px,py,8)

			love.graphics.setColor(0, 0, 1)
			local lx = self.last.x + px
			local ly = self.last.y + py
			love.graphics.circle("line", lx, ly, 10)


		end
	end

end


function testscene:newlevel()

	local seed = love.timer.getTime()
	local rng = love.math.newRandomGenerator(seed)
	self.level = levelgen.brids(self.w, self.h, 8, 200, self.min, self.max, rng)
	
	self.level = levelgen.generate(self.level, 0, rng)
	
	--levelgen.generate(self.level, rng)

	local ep, d = levelgen.getFarthest(self.level)

	self.dist = d
	self.endpoint = self.level[self.level.finish]
	self.last = self.level[#self.level]
	
	if self.debugmsg then
		self.debugmsg = self:debuglevel()
	end

end


function testscene:toggledebug()
	if self.debugmsg then
		self.debugmsg = false
	else
		self.debugmsg = self:debuglevel()
	end
end


function testscene:debuglevel()
	
	local dbg = ""
	
	if self.level then

		dbg = "Failed nodes:"

		for _, fi in ipairs(self.level.debug) do
			dbg = dbg.." "..fi
		end

		for node, data in ipairs(self.level) do
			dbg = dbg.."\n"..node..":"
			for _, i in ipairs(data.neighbors) do
				dbg = dbg.." "..i
			end
		end
			
	end
	
	return dbg
end

return testscene
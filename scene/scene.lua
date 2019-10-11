local util = require("util")

local scene = {}

scene.__index = scene
setmetatable(scene, {
		__call = function (cls, ...)
			local self = setmetatable({}, cls)
			self:_init(...)
			return self
		end,
	})


function scene:_init(...)

	self.widgets = {}
	self.count = select("#",...)
	for i=1, select("#",...) do
		self.widgets[i] = select(i,...)
		self.widgets[i].owner = self
	end

	self.newscene = self

	--self.drawpress = true
	self.presstime = 0
	self.pressarea = {0, 0, 0, 0}
	self.presshit = {0, 0}

	self.scale = 2
	local sw, sh = love.graphics.getDimensions()

	self.w = sw / self.scale
	self.h = sh / self.scale

	self.canvas = love.graphics.newCanvas(sw / self.scale, sh / self.scale)
	self.canvas:setFilter( "linear", "nearest" )

	self.width = self.canvas:getWidth()
	self.height = self.canvas:getHeight()

end


function scene:input(x, y)

	if self.subscene then
		self.subscene:input(x, y)
	else
		local x = x / self.scale
		local y = y / self.scale
		for i, w in ipairs(self.widgets) do
			if w.input then
				local wx, wy = util.anchorpoints(w, self.width, self.height)
				if (x > wx and x < wx + w.w) then
					if (y > wy and y < wy + w.h) then
						w.input(self)
						self.presstime = love.timer.getTime()
						self.pressarea = {x1, y1, x2, y2}
						self.presshit = {x, y}
						return
					end
				end
			end
		end
	end
end


function scene:presskey(key)
	if self.subscene then
		self.subscene:presskey(key)
	else
		for i, w in ipairs(self.widgets) do
			if w.input then
				if w.key == key then
					--self.debugmsg = key
					w.input(self)
				end
			end
		end
	end
end


function scene:goprevious()
	self.newscene = self.previousscene
end


function scene:goback()
	if self.subscene then
		self.subscene:goback()
	else
		if self.parent then
			self.parent.subscene = nil
			if self.quit then self:quit() end
		else
			self:goprevious()
		end
	end
end


function scene:addsubscene(sub)
	sub.parent = self
	sub.canvas = self.canvas
	sub.scale = self.scale
	self.subscene = sub
end


function scene:addwidget(w)
	w.owner = self
	self.widgets[#self.widgets + 1] = w
end


function scene:updateScene(dt)
	if self.subscene then
		self.subscene:updateScene(dt)
	else
		if self.update then
			self:update(dt)
		end

		for i, w in ipairs(self.widgets) do
			if w.update then
				w.update(self, dt)
			end
		end
	end

	return self.newscene
end


function scene:drawScene()

	if not self.parent then
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear(0, 0, 0, 0)
	end

	if self.draw then
		self:draw()
	end

	for i, w in ipairs(self.widgets) do
		if w.draw then
			w:draw(self.width, self.height)
		end
	end

	if self.drawpress then
		local alpha = 24
		local dt = love.timer.getTime() - self.presstime
		local a = alpha - math.min(dt*2, 1) * alpha
		love.graphics.setColor(255, 255, 255, a)
		love.graphics.rectangle("fill", self.pressarea[1], self.pressarea[2], self.pressarea[3], self.pressarea[4])
		love.graphics.circle("fill", self.presshit[1], self.presshit[2], 80)
	end

	if self.debug then
		love.graphics.setColor(self.debug)
		for i, w in pairs(self.widgets) do
			love.graphics.rectangle("line", w.x, w.y, w.w, w.h)
		end
	end

	if self.subscene then
		self.subscene:drawScene()
	end
	
	if self.debugmsg then
		love.graphics.setColor(255,0,0)
		love.graphics.print(self.debugmsg, 10, 16)
	end

	-- Draw canvas
	if not self.parent then
		--love.graphics.setCanvas()
		--love.graphics.setColor(255,255,255)
		--love.graphics.draw(self.canvas, 0, 0, 0, self.scale)
	end
end


return scene


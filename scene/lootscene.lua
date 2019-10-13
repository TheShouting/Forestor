local scene = require("scene.scene")

local button = require("widget.button")


local lootscene = {}

lootscene.__index = lootscene
setmetatable(lootscene, {
		__index = scene,
		__call = function (cls, ...)
			local self = setmetatable({}, cls)
			self:_init(...)
			return self
		end,
	})

function lootscene:_init(player)

	self.player = player
	self.container = player.loot
	
	self.border = 32
	
	local loot = self.player.loot
	local destroybutton = nil
	if loot.rot and  loot.rot > 0 then
		destroybutton = button("DESTROY", self.destroy, -self.border, self.border, 128, 32, 1, 0, 1, 0)
	end
	destroybutton.key = "space"
	
	local closebutton = button("CLOSE", self.goback, self.border, self.border, 128, 32, 0, 0, 0, 0)
	
	local rmsg = self.container.right and
	self.container.right.name or "[EMPTY]"
	
	local lmsg = self.container.left and
	self.container.left.name or "[EMPTY]"
	
	self.right = button(rmsg, self.takeright, -10, 0, 128, 32, 0.5, 0.5, 1, 0.5)
	self.right.key = "right"
	self.left = button(lmsg, self.takeleft, 10, 0, 128, 32, 0.5, 0.5, 0, 0.5)
	self.left.key = "left"
	
	scene._init(self, closebutton, destroybutton, self.right, self.left)

end

function lootscene:quit()
	self.player.loot = nil
end

function lootscene:destroy()
	self.player.loot.rot = 0
	self:goback()
end

function lootscene:take(id)

	local prop = self.container[id]
	self.container[id] = self.player[id]
	self.player[id] = prop

	if type(self[id]) == "table" then
		self[id].text = self.container[id] and
		self.container[id].name or "[EMPTY]"
	end
end

function lootscene:takeleft()
	self:take("left")
end

function lootscene:takeright()
	self:take("right")
end

function lootscene:draw()
	local sw, sh = self.canvas:getDimensions()

	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill",
		self.border, self.border,
		sw - self.border * 2, sh - self.border * 2)
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("line",
		self.border, self.border,
		sw - self.border * 2, sh - self.border * 2)
end

return lootscene
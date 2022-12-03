local scene = require("scene.scene")
local gamescene = require("scene.gamescene")
local testscene = require("scene.testscene")
local button = require("widget.button")

local world = require("game.world")
local generate = require("gen.generate")

local util = require("util")

local menuscene = {}

menuscene.__index = menuscene
setmetatable(menuscene, {
	__index = scene,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function menuscene:_init()

	scene._init(self,
		button("NEW GAME", self.newgame, 4, -4, 96, 32, 0, 1, 0, 1),
		button("QUIT", self.quitgame, 0, -4, 96, 32, 0.5, 1, 0.5, 1),
		button("CONTINUE", self.loadgame, -4, -4, 96, 32, 1, 1, 1, 1),
		button("test", self.test, 4, 128, 128, 32)
		)
	
	self.title = love.graphics.newImage('assets/img/title.png')

end

function menuscene:draw()

	local v = math.sin(love.timer.getTime()) * 0.5 + 0.5
	local col = util.lerprgb({64, 96, 128}, {200, 164, 0}, v)
	love.graphics.setColor(love.math.colorFromBytes(col))
	
	love.graphics.draw(self.title, 40, 40)
end

function menuscene:newgame()
	world.new(50, 50)
	world.seed = love.timer.getTime()
	world.generate()
	self.newscene = gamescene(world)
	self.newscene.previousscene = self
end

function menuscene:loadgame()
	world.new(50, 50)
	world.generate()
	self.newscene = gamescene(world)
	self.newscene.previousscene = self
end

function menuscene:test()
	self.newscene = testscene()
	self.newscene.previousscene = self
end

function menuscene:quitgame()
	self.newscene = nil
end

return menuscene
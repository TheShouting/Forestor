local scene = require("scene.scene")
local world = require("game.world")
local mapgen = require("gen.mapgen")

local game = require("scene.game")
local hud = require("scene.hud")

local gamescene = {}

gamescene.__index = gamescene
setmetatable(gamescene, {
   __index = scene,
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function gamescene:_init()

   self.world = world
   
   -- set touch input areas
			local sw = love.graphics.getWidth()
   local sh = love.graphics.getHeight()
			local z1 = {
			   x=0, y=sh*0.25, w=sw*0.25, h=sh*0.5, 
			   input=function(self, t) 
			      world.update(-1, 0)
			      world.timer = t
			   end}
			local z2 = {
			   x=0, y=0, w=sw, h=sh*0.25,
			   input=function(self, t) 
			      world.update(0, -1)
			      world.timer = t
			   end}
			local z3 = {
			   x=sw*0.75, y=sh*0.25, w=sw*0.25, h=sh*0.5,
			   input=function(self, t) 
			      world.update(1, 0)
			      world.timer = t
			   end}
			local z4 = {
			   x=0, y=sh*0.75, w=sw, h=sh*0.25,
			   input=function(self, t) 
			      world.update(0, 1)
			      world.timer = t
			   end}
			local z5 = {
			   x=sw*0.25, y=sh*0.25, w=sw*0.5, h=sh*0.5,
			   input=function(self, t) 
			      world.update(0, 0)
			      world.timer = t
			   end}

   world.new(150, 150)
   local map = mapgen.generate(150, 150, 0)
   world.fill(map)
   
   
   self.game = game(60, 60, sw-120, sh-120, world)
   self.hud = hud(60, sh-60, sw-120, 60, world.player)
   
   scene._init(self, z1, z2, z3, z4, z5)
   
end

function gamescene:update(dt)
   self.game.timer = love.timer.getTime()
   self.game:update(dt)
   self.hud:update(dt)
end

function gamescene:draw()
   self.game:draw()
   self.hud:draw()
end

return gamescene
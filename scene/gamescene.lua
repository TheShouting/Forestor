local scene = require("scene.scene")
local game = require("widget.game")
local hud = require("widget.hud")
local button = require("widget.button")
local slot = require("widget.slot")

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

function gamescene:_init(world)

   self.time = 0
   self.world = world

   local sw = love.graphics.getWidth()
   local sh = love.graphics.getHeight()

   -- set draw areas
   self.game = 
      game(60, 60, sw-120, sh-120, world)
   self.hud = hud(0, 0, sw, sh, world.player)
   
   -- set touch input areas
			
			local z1 = {
			   x=0, y=sh*0.25, w=sw*0.25, h=sh*0.5, 
			   input=function(self) 
			      self.world.input(-1, 0)
			   end}
			local z2 = {
			   x=0, y=0, w=sw, h=sh*0.25,
			   input=function(self) 
			      self.world.input(0, -1)
			   end}
			local z3 = {
			   x=sw*0.75, y=sh*0.25, w=sw*0.25, h=sh*0.5,
			   input=function(self) 
			      self.world.input(1, 0)
			   end}
			local z4 = {
			   x=0, y=sh*0.75, w=sw, h=sh*0.25,
			   input=function(self) 
			      self.world.input(0, 1)
			   end}
			local z5 = {
			   x=sw*0.25, y=sh*0.25, w=sw*0.5, h=sh*0.5,
			   input=function(self) 
			      self.world.input(0, 0)
			   end}
   
   scene._init(self, z1, z2, z3, z4, z5)
   
end

function gamescene:start()
   -- game is loaded here
end

function gamescene:update(dt)
   
   local t = love.timer.getTime()
   
   self.world.update(t)
   
   self.game:update(dt)
   self.hud:update(dt)
   
end

function gamescene:draw()
   self.game:draw()
   self.hud:draw()
   
   if self.world.debug then
      love.graphics.setColor(255,0,0)
      love.graphics.print(self.world.debug,10,100)
   end
   
end

return gamescene
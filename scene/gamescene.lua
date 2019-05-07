local scene = require("scene.scene")
local game = require("widget.game")
local hud = require("widget.hud")
local button = require("widget.button")
local lootmenu = require("scene.lootscene")

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

   scene._init(self)

   self.time = 0
   self.world = world

   -- set draw areas
   self.game = game(world)
   self.hud = hud(0, 0, sw, sh, world.player)
   
   -- set touch input areas
			
			self:addwidget( {
			   x=0, y=0, w=self.width/4, h=self.height,
			   ax=0, ay=0, aw=0, ah=0,
			   input=function(self) 
			      self.world.input(-1, 0)
			   end} )
			self:addwidget( {
			   x=0, y=0, w=self.width, h=self.height/4,
			   ax=0, ay=0, aw=0, ah=0,
			   input=function(self) 
			      self.world.input(0, -1)
			   end} )
			self:addwidget( {
			   x=0, y=0, w=self.width/4, h=self.height,
			   ax=1, ay=0, aw=1, ah=0,
			   input=function(self) 
			      self.world.input(1, 0)
			   end} )
			self:addwidget( {
			   x=0, y=0, w=self.width, h=self.height/4,
			   ax=0, ay=1, aw=0, ah=1,
			   input=function(self) 
			      self.world.input(0, 1)
			   end} )
			self:addwidget( {
			   x=0, y=0, w=self.width/2, h=self.height/2,
			   ax=0.5, ay=0.5, aw=0.5, ah=0.5,
			   input=function(self) 
			      self.world.input(0, 0)
			   end} )
   
end

function gamescene:start()
   -- game is loaded here
end

function gamescene:update(dt)
   
   local t = love.timer.getTime()
   
   self.world.update(t)
   
   if self.world.player.loot then
      self:addsubscene(
         lootmenu(self.world.player))
      return
   end
   
   self.game:update(dt)
   self.hud:update(dt)
   
end

function gamescene:draw()

   local sw, sh = self.canvas:getDimensions()
   
   self.game:draw(sw, sh)
   self.hud:draw(sw, sh)
   
   if self.world.debug then
      love.graphics.setColor(255,0,0)
      love.graphics.print(self.world.debug,10,100)
   end
   
end

return gamescene
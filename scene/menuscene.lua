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
     button("NEW GAME", self.newgame, 1200, 500),
     button("CONTINUE", self.loadgame, 1200, 650),
     button("QUIT", self.quitgame, 1200, 800),
     button("test", self.test, 200, 800))
     
   self.title =
      love.graphics.newImage(
      'assets/img/title.png')

end

function menuscene:draw()

   local v = 
      math.sin(love.timer.getTime()) * 0.5 + 0.5
   local col = util.lerprgb(
      {64, 96, 128}, 
      {200, 164, 0}, 
      v)
   love.graphics.setColor(col)
   
   love.graphics.draw(self.title, 200, 240, 0, 2, 2, 0, 0)
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
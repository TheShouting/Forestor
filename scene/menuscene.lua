local scene = require("scene.scene")
local gamescene = require("scene.gamescene")
local button = require("widget.button")

local world = require("game.world")
local mapgen = require("gen.mapgen")

local tileset = require("assets.tileset")

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
     button("QUIT", self.quitgame, 1200, 800))
     
   self.title =
      love.graphics.newImage(
      'assets/img/title.png')
      
   self.set = tileset:load("ground", 16, 32)

end

function menuscene:draw()

   local t = 
      {2, 3, 4, 2, 3, 2, 2, 2, 2, 3, 2, 
      5, 6, 7,
      2, 4, 3, 2, 2, 2, 3, 2, 2, 3, 4}
   love.graphics.setColor(255, 255, 255)
   for i = 1, #t do
      love.graphics.draw(
         self.set.img, 
         self.set.tile[t[i]],
         50 + (i * 64), 50, 0, 4, 4, 0, 0)
   end

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
   world.new(150, 150)
   local map = mapgen.generate(150, 150, 0)
   world.fill(map)
   
   self.newscene = gamescene(world)
end

function menuscene:loadgame()
   self:newgame()
end

function menuscene:quitgame()
   self.newscene = nil
end

return menuscene
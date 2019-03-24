local tools = require("gen.tools")
local objects = require("game.objects")
local stage = require("gen.stage")
local biome = require("gen.biome")

local clearmap = function(world, rng)
   for x=1, world.width do
      for y=1, world.height do
         world.map[x][y].id = "blank"
         world.map[x][y].prop = nil
         world.map[x][y].rand = rng:random(0, 99)
         world.map[x][y].state = ""
         world.map[x][y].time = 0
         world.map[x][y].see = false
         world.map[x][y].obj = nil
      end
   end
end

local fillmap = function(world, map)
   for x=1, map.w do
      for y=1, map.h do
         world.map[x][y].id = map[x][y]
         world.map[x][y].prop = nil
      end
   end
end

local run = function(world)
-- 1. place points of interests 
--    (keys, locks, containers, etc)

-- 2. draw path to objective (designate areas 
--    that cannot be blocked)

-- 3. make biome

-- 4. apply set piece to points of interest

-- 5. populate with entities and objects

   local lvl = world.level
   local seed = world.seed

   local rng = 
      love.math.newRandomGenerator(seed + lvl)
      
   clearmap(world, rng)
   
   local level = tools.make(
       world.width, world.height, false)
   
   -- create points of interest and draw a path
   -- between them
   local points = {}
   local count = 3
   points[0] = {x=1, y=1}
   for i = 1, count do
      points[i] = {
         x = rng:random(world.width),
         y = rng:random(world.height)}
      tools.road(level, 
         points[i-1].x, points[i-1].y,
         points[i].x, points[i].y,
         true)
   end
   
   -- create biome
   local map = biome.forest(level, rng)
   
   local rands = {
      stage.pond,
      stage.room}
   -- apply points of interest
   for k, v in pairs(points) do
      local r = rng:random(#rands)
      rands[r](map, level, v.x, v.y, rng)
   end
   
   map[points[#points].x][points[#points].y] =
      "portal"
   
   fillmap(world, map)
   
   world.insert(
      objects.dummy("portal", world.nextlevel),
      points[#points].x, points[#points].y)
      
   world.map[2][1].prop = objects.prop("axe")
   
   local move = world.propertymap("move")
   
end

local generate = {
   run = run
   }
   
return generate





local tools = require("gen.tools")
local objects = require("game.objects")

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

   -- My very hacky level generation
   
-- 1. place points of interests 
--    (keys, locks, containers, etc)

-- 2. draw path to objective

-- 3. make biome

-- 4. apply type of interest point

-- 5. populate with entities and objects

   local lvl = world.level
   local seed = world.seed

   local rng = 
      love.math.newRandomGenerator(seed + lvl)
      
   clearmap(world, rng)
      
   local map = tools.make(
       world.width, world.height, "dirt")
   tools.noise(map, 0.45, "grass", rng)
   tools.noise(map, 0.25, "tree", rng)
   tools.noise(map, 0.15, "puddle", rng)
   
   local portalx = rng:random(map.w)
   local portaly = rng:random(map.h)
   
   tools.line(map, 1, 1, portalx, portaly, "path")
   
   map[portalx][portaly] = "portal"
   
   fillmap(world, map)
   
   world.insert(objects.dummy("portal", world.nextlevel), portalx, portaly)
   
   local monster = objects.actor("goblin")
   monster.right = objects.prop("axe")
   world.insert(monster, 5, 3)
   world.insert(objects.actor("goblin"), 8, 1)
   
   --world.insert(objects.dummy("dummy"), -5, 1)
   
   --world.insert(
   --   objects.container(objects.prop("axe")),
   --   3, 3)
   
   world.map[4][2].prop = objects.prop("sword")
   world.map[2][5].prop = objects.prop("shield")
   
end

local generate = {
   run = run,
   fillmap = fillmap
   }
   
return generate





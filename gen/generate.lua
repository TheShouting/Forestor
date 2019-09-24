local tools = require("gen.tools")
local objects = require("game.objects")
local stage = require("gen.stage")
local biome = require("gen.biome")
local levelgen = require("gen.levelgen")

local effects = require("game.effects")

local clearmap = function(world, rng)
	for x=1, world.width do
		for y=1, world.height do
			world.map[x][y].id = "blank"
			world.map[x][y].prop = nil
			world.map[x][y].rand = rng:random(0, 99)
			world.map[x][y].state = ""
			world.map[x][y].time = 0
			world.map[x][y].see = false
			world.map[x][y].bitmask = 0
			--world.map[x][y].obj = nil
		end
	end
end

local fillmap = function(world, map)
	for x=1, map.w do
		for y=1, map.h do
			world.map[x][y].id = map[x][y]
			--world.map[x][y].prop = nil
		end
	end

	world.makeneighbormap()
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

	local rng = love.math.newRandomGenerator(seed + lvl)

	clearmap(world, rng)

	--local level = levelgen.makeLevel(
	--   world.width, world.height, 6, 3, rng)

	local min_radius = 10
	local level = levelgen.brids(world.width, world.height, 8, 20, min_radius, 16, rng)

	-- create biome
	local map, path = biome.forest(level, rng)
	--local map, path = biome.empty(level, rng)

	local levelend, _ = levelgen.getFarthest(level)
	--local levelend = #level
	local levelstart = 1

	local items = {
		"axe",
		"sword",
		"shield",
		"hammer",
		"potion"
	}
	local object = {
		"goblin"
	}

	-- apply points of interest
	for i=1, #level do
		local r = rng:random()
		local stg = nil
		local n = level[i]
		local itm = items[rng:random(#items)]
		local obj = object[rng:random(#object)]
		
		if i == levelstart then
			stg = stage.start
		elseif i == levelend then
			stg = stage.finish
		elseif #n.neighbors > 2 then
			stg = stage.crossroad
			world.map[n.x][n.y].prop = objects.prop(itm)
			if r > 0.25 then
				world.insert(objects.actor(obj), n.x, n.y)
			end
		elseif #n.neighbors > 1 then
			stg = stage.passage
			if r > 0.25 then
				world.insert(objects.actor(obj), n.x, n.y)
			end
		else
			stg = stage.endpoint
			world.map[n.x][n.y].prop = objects.prop(itm)
			if r > 0.25 then
				world.insert(objects.actor(obj), n.x, n.y)
			end
		end
		r = rng:random(#stg)
		stg[r](map, path, n.x, n.y, math.ceil(n.size / 2), rng, false)
	end

	map[level[levelend].x][level[levelend].y] = "portal"
	world.insert(objects.dummy("portal", world.nextlevel), level[levelend].x, level[levelend].y)

	fillmap(world, map)

	local p = objects.prop("hammer")
	--p.hiteffects = {effects.hit.cut}
	world.map[2][2].prop = effects.brittle(p)

	--local move = world.propertymap("move")

end

local generate = {
	run = run
}

return generate





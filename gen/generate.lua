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

	local min_size = 6
	local max_size = 12
	local level = levelgen.brids(world.width, world.height, 8, 20, min_size, max_size, rng)
	
	level = levelgen.generate(level, rng)

	local map = tools.make(world.width, world.height, "roughgrass")
	
	-- Create paths between doors
	for i = 1, #level do
		for d = 1, #level[i].doors do
			local dest = level[i].doors[d].destination
			if (dest > i) then
				for n = 1, #level[dest].doors do
					if level[dest].doors[n].destination == i then
						local x1 = level[i].doors[d].x
						local y1 = level[i].doors[d].y
						local x2 = level[dest].doors[n].x
						local y2 = level[dest].doors[n].y
						tools.line(map, x1, y1, x2, y2, "path")
						break
					end
				end
			end
		end
	end
	
	-- create biome
	--local map, path = biome.forest(level, rng)
	--local map, path = biome.empty(level, rng)

	local levelend, _ = levelgen.getFarthest(level)
	--local levelend = #level
	local levelstart = 1

	-- apply points of interest
	for i=1, #level do
		local r = rng:random()
		local stg = nil
		local n = level[i]
		--local itm = items[rng:random(#items)]
		--local obj = object[rng:random(#object)]
		
		if i == levelstart then
			stg = stage.start
		elseif i == levelend then
			stg = stage.finish
		elseif #n.neighbors > 2 then
			stg = stage.crossroad
		elseif #n.neighbors > 1 then
			stg = stage.passage
		else
			stg = stage.endpoint
		end
		r = rng:random(#stg)
		stg[r](map, n, rng) -- Place stage on map
	end

	map[level[levelend].x][level[levelend].y] = "portal"
	world.insert(objects.dummy("portal", world.nextlevel), level[levelend].x, level[levelend].y)
	
	
	for _, n in ipairs(level) do
		for _, d in ipairs(n.doors) do
			map[d.x][d.y] = "wall"
		end
	end
	

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





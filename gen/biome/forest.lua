local tools = require("gen.tools")

local forest = { 
	... --meta-fields here 
} 

forest.forest = function(level, rng)
	local w = level.w
	local h = level.h
	local map = tools.make(w, h, "tree")
	local path = tools.make(w, h, false)

	for i = 1, #level do
		local neighbors = level[i].neighbors
		for _, n in pairs(neighbors) do
			if n > i then
				tools.path(path, level[i].x, level[i].y, level[n].x, level[n].y, true, 4, rng)
			end
		end
	end
	--tools.grow(map, true, 1)

	tools.stencil(map, path, true, "grass")

	tools.noise(map, 0.35, "grass", rng)
	for i = 1, 3 do
		tools.cellauto(map, "tree", "grass")
	end

	tools.stencil(map, path, true, "grass")

	local ground = tools.make(w, h, "dirt")
	tools.noise(ground, 0.5, "grass", rng)
	for i = 1, 2 do
		tools.cellauto(ground, "grass", "dirt")
	end
	tools.apply(ground, map, "grass")
	tools.stencil(ground, path, true, "path")

	local grass = tools.make(w, h, "dirt")
	tools.noise(grass, 0.4, "tallgrass", rng)
	for i = 1, 3 do
		tools.cellauto(grass, "tallgrass", "dirt")
	end

	tools.apply(ground, grass, "dirt")

	map = tools.apply(ground, map, "grass")

	return map, path

end 

setmetatable(forest, { 
		__call = function(_, map, rng) 
			return forest.forest(map, rng)
		end 
	}) 

return forest
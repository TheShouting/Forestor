local tools = require("gen.tools")


local generate = function(level, depth, rng)
	
	local w = level.w
	local h = level.h
	local map = tools.make(w, h, "blank")
	
	map.loot = {}
	map.spawn = {}
	map.area = {}

	map.doors = {}

	for i = 1, #level do
		local doors = {}
		local area = {level[i].x - level[i].size, level[i].x - level[i].size, level[i].size * 2, level[i].size * 2}
		
		
		for n_i, n in pairs(level[i].neighbors) do
			doors[n_i] = n
			
			local dx, dy = tools.distanceaxis(level[i],x, level[i].y, level[n_i].x, level[n_i].y, w, h)
			
			local x, y
			if dx > dy then
			
			else
			end
		end
		
		
		
		
		map.area[i] = area
		map.doors[i] = doors
	end

	return map
end


local mapgen = {
	generate = generate
}


return mapgen
local tools = require("gen.tools")

local cave = {
... --meta-fields here
}


cave.cave = function(map, path, x, y, rad, rng, key)

	local size = rng:random(3, rad)
	
	local cave = tools.make(size*2+1,size*2+1,"blank")
	
	tools.clear(cave, size, size, size, "cliff")
	  
	tools.noise(cave, 0.25, "dirt", rng)
	
	tools.clear(cave, size, size, 2, "dirt")
	
	tools.noise(cave, 0.05, "cliff", rng)
	
	for cx = 1, cave.w do
		for cy = 1, cave.h do
			local px = (x + cx - math.floor(cave.w / 2) + map.w - 1) % map.w + 1
			local py = (y + cy - math.floor(cave.h / 2) + map.h - 1) % map.h + 1
			if path[px][py] then
				cave[cx][cy] = "path"
			end
		end
	end
	
	local px = x - size
	local py = y - size
	tools.apply(map, cave, "blank", px, py)
	
	return nil
end


setmetatable(cave, {
__call = function(_, map, x, y, rad, rng, key)
  return cave.cave(map, x, y, rad, rng, key)
end

	
})

return cave
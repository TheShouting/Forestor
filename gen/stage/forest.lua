local tools = require("gen.tools")

local forest = {
... --meta-fields here
}


forest.forest = function(map, path, x, y, rad, rng, key)

	local size = rng:random(3, rad)
	
	local fmap = tools.make(size*2+1,size*2+1,"blank")
	
	tools.clear(fmap, size, size, 2, "grass")
	
	for cx = 1, fmap.w do
		for cy = 1, fmap.h do
			local px = (x + cx - math.floor(fmap.w / 2) + map.w - 1) % map.w + 1
			local py = (y + cy - math.floor(fmap.h / 2) + map.h - 1) % map.h + 1
			if path[px][py] then
				fmap[cx][cy] = "grass"
			end
		end
	end
	
	local px = x - size
	local py = y - size
	tools.apply(map, fmap, "blank", px, py)
	
	return nil
end


setmetatable(forest, {
__call = function(_, map, x, y, rad, rng, key)
  return forest.forest(map, x, y, rad, rng, key)
end

	
})

return forest
local tools = require("gen.tools")

local meadow = {
	... --meta-fields here
	}
   
meadow.meadow = function(map, node, rng)
	
	local size = math.floor(node.size / 2) - 1
	
	local area = tools.make(size*2, size*2, "grass")
	
	local rx = node.x - size
	local ry = node.y - size
	tools.apply(map, area, "blank", rx, ry)
	
	for _, d in ipairs(node.doors) do
		tools.path(map, d.x, d.y, node.x, node.y, "flowers", 3, rng)
	end

end

setmetatable(meadow, {
	__call = function(_, map, node, rng)
		return meadow.meadow(map, node, rng)
	end
	})
   
return meadow
local tools = require("gen.tools")

local pond = {
	... --meta-fields here
	}

pond.pond = function(map, path, x, y, rad, rng, key)

	local size = rng:random(3, rad)
	
	local pond = tools.make(size*2+1,size*2+1,"blank")
	
	tools.clear(pond, size, size,
	  size-0.5, "puddle")
	  
	tools.noise(pond, 0.35, "tallgrass", rng)
	  
	tools.clear(pond, size, size, size-1.5, "puddle")
	  
	tools.clear(pond, size, size, 1.25, "tallgrass")
	
	--tools.noise(pond, 0.05, "flower", rng)
	
	local px = x - size
	local py = y - size
	tools.apply(map, pond, "blank", px, py)
	
	return nil
end

setmetatable(pond, {
	__call = function(_, map, x, y, rad, rng, key)
		return pond.pond(map, x, y, rad, rng, key)
	end
	})
   
return pond
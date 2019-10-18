local tools = require("gen.tools")

local room = {
   ... --meta-fields here
   }
   
room.room = function(map, node, rng)
	
	local size = math.floor(node.size / 2) - 1
	
	local area = tools.make(size*2, size*2, "dirt")
	
	local rx = node.x - size
	local ry = node.y - size
	tools.apply(map, area, "blank", rx, ry)
	
	for _, d in ipairs(node.doors) do
		tools.path(map, d.x, d.y, node.x, node.y, "floor", 3, rng)
	end

end

setmetatable(room, {
   __call = function(_, map, node, rng)
      return room.room(map, node, rng)
   end
   })
   
return room
local room = require("gen.stage.room")
local meadow = require("gen.stage.meadow")

local stage = {
	start = {
		meadow,
		room
	},
	finish = {
		meadow,
		room
	},
	endpoint = {
		meadow,
		room
	},
	crossroad = {
		meadow
	},
	passage = {
		meadow,
		room
	}
}

return stage
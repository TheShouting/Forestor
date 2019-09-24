local room = require("gen.stage.room")
local pond = require("gen.stage.pond")
local meadow = require("gen.stage.meadow")
local cave = require("gen.stage.cave")
local forest = require("gen.stage.forest")


local stage = {
	start = {
		meadow,
		room,
		cave
	},
	finish = {
		room,
		pond,
		cave
	},
	endpoint = {
		room,
		meadow,
		pond,
		cave
	},
	crossroad = {
		meadow,
		pond,
		forest
	},
	passage = {
		forest,
		cave
	}
}

return stage
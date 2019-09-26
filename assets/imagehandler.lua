local tileset = require("data.tileset")
local spriteset = require("data.spriteset")

local imagehandler = {}

imagehandler.__index = imagehandler
setmetatable(imagehandler, {
	__call = function (cls, ...)
	local self = setmetatable({}, cls)
	self:_init(...)
		return self
	end,
	})

function imagehandler:_init(...)

	local sheetfiles = {}
	self.sheets = {}
	
	for i = 1, select("#",...) do
		for _, tile in pairs(select(i, ...)) do
			if type(tile) == "table" then
			sheetfiles[tile.sheet] = true
			end
		end
		
		for file, _ in pairs(sheetfiles) do
			local img = love.graphics.newImage("assets/img/"..file..".png")
			img:setFilter( "linear", "nearest" )
			self.sheets[file] = img
		end
	end

end


function imagehandler:drawtile(x, y, tile, bitmask, rval, scale)

	scale = scale or 1
	local sheet = self.sheets[tile.sheet]
	
	local img = tile.images[1]
	if tile.bitmask then
		img = tile.images[bitmask + 1]
	elseif tile.animate then
		local i = (love.timer.getTime() + rval) / tile.animate
		i = math.floor(i - 1) % #tile.images + 1
		img = tile.images[i]
	else
		rval = math.floor(rval)
		img = tile.images[rval % #tile.images + 1]
	end
	
	local quad = love.graphics.newQuad(img[1], img[2], img[3], img[4], sheet:getWidth(), sheet:getHeight() )
	love.graphics.draw(sheet, quad, x - img[3] * 0.5, y - img[4], 0, scale, scale, 0, 0)
end


function imagehandler:drawsprite(x, y, sprite, state, scale)

	scale = scale or 1
	
	local images = sprite[state]
	if not images then
		images = sprite["idle"]
	end
	
	local sheet = self.sheets[sprite.sheet]
	
	local img = images[1]
	local quad = love.graphics.newQuad(img[1], img[2], img[3], img[4], sheet:getWidth(), sheet:getHeight() )
	love.graphics.draw(sheet, quad, x - img[3] * 0.5, y - img[4], 0, scale, scale, 0, 0)
end

return imagehandler
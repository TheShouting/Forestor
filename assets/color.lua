
local lumin = function(c)
	return (c[1]*0.3 + c[2]*0.59 + c[3]*0.11) / 255
end

local lerprgb = function(a, b, t)
	local r = a[1] + (b[1] - a[1]) * t
	local g = a[2] + (b[2] - a[2]) * t
	local b = a[3] + (b[3] - a[3]) * t
	return {r, g, b}
end


local processcolor = function(color, t, offset)

	offset = offset or 0

	local ncol = color
	if (color.ember) then
		local v = math.sin((t+offset)* 8)*0.5+0.5
		ncol = lerprgb(color.ember, ncol, v)
	end
	if (color.sin) then
		t = love.timer.getTime()
		local v = math.sin(t*6) * 0.5 + 0.5
		ncol = lerprgb(color.sin, ncol, v)
	end
	if (color.fsin) then
		local v = math.sin(t*24) * 0.5 + 0.5
		ncol = lerprgb(color.fsin, ncol, v)
	end
	if (color.blink) then
		local dt = t - color.time
		local v = math.min(dt * 2, 1)
		ncol = lerprgb(color.blink, ncol, v)
	end
	if (color.fade) then
		local dt = t - color.time
		local v = math.min(dt * 0.5, 1)
		ncol = lerprgb(color.fade, ncol, v)
	end

	return ncol
end


local color = {

   highlight = {255, 255, 255},
   shadow = {0, 0, 0},
   green = {180, 210, 120},
   brown = {210, 180, 120},
   blue = {120, 210, 180},
   stone = {196, 196, 196},
   bright = {255, 128, 255},
   
   lumin = lumin,
   lerprgb = lerprgb,
   processcolor = processcolor,
   
   getColor = function(self, col)
		if not self[col] then
			col = "default"
		end
		local c = {}
		for k, v in pairs(self[col]) do
			c[k] = v
		end
		return c
	end
}


return color
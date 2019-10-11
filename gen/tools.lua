-- tools module
-- for manipulating map tables containing
-- w: width
-- h: height
-- 2d indices: map data of any type

local copy = function(map)
	local c = {w = map.w, h = map.h}
	for x = 1, map.w do
		c[x] = {}
		for y = 1, map.h do
			c[x][y] = map[x][y]
		end
	end
	return c
end


local make = function(w, h, fill)

	local map = {w=w, h=h}

	for x = 1, w do
		map[x] = {}
		for y = 1, h do
			map[x][y] = fill
		end
	end

	return map
end


local pointdiff = function(p1, p2, size)
	return math.min(
		math.abs(p1-p2),
		size-math.abs(p1-p2))
end


local stencil = function(map, stencil, a, b)
	for x = 1, map.h do
		for y = 1, map.w do
			local sx = (x - 1) % stencil.w + 1
			local sy = (y - 1) % stencil.h + 1
			if stencil[sx][sy] == a then
				map[x][y] = b
			end
		end
	end
	return map
end


local cellauto = function(map, a, b)

	s8 = {{1,0}, {1,1}, {0,1}, {-1,1},
		{-1,0},{-1,-1},{0, -1},{1, -1}}

	local nmap = make(map.w, map.h, b)
	for x=1, map.w do
		for y=1, map.h do
			local n = 0

			for k, s in pairs(s8) do
				local sx = (x + s[1] - 1) % map.w + 1
				local sy = (y + s[2] - 1) % map.h + 1
				if (map[sx][sy] == a) then
					n = n + 1
				end
			end

			if (map[x][y] == a and n >= 4) then
				nmap[x][y] = a
			end
			if (map[x][y] == b and n >= 5) then
				nmap[x][y] = a
			end
		end
	end

	for x=1, map.w do
		for y=1, map.h do
			if map[x][y]==a or nmap[x][y]==a then
				map[x][y] = nmap[x][y]
			end
		end
	end

	return map
end


local clear = function(m, cx, cy, size, c)

	local radius = math.ceil(size)

	for x = -radius, radius do
		for y = -radius, radius do
			local d = x*x + y*y
			if d < size * size then
				local px = (cx + x - 1) % m.w + 1
				local py = (cy + y - 1) % m.h + 1
				m[px][py] = c
			end
		end
	end
	return m

end


local clearrect = function(map, x, y, r, c)

	local r1 = math.floor(r*0.5 + 0.5)
	local r2 = math.ceil(r*0.5 - 0.5) - 1


	for w = -r1, r2 do
		for h = - r1, r2 do
			local px = (x + w - 1) % map.w + 1
			local py = (y + h - 1) % map.h + 1
			map[px][py] = c
		end
	end

	return map

end


local apply = function(map, stamp, a, sx, sy)

	sx = sx or 0
	sy = sy or 0

	for x = 1, stamp.w do
		for y = 1, stamp.h do
			local t = stamp[x][y]
			if t ~= a then
				local px = (x + sx - 1) % map.w + 1
				local py = (y + sy - 1) % map.h + 1
				map[px][py] = t
			end
		end
	end

	return map
end


local noise = function(map, n, a, rng)
	for x=1, map.w do
		for y=1, map.h do
			if (rng:random() < n) then
				map[x][y] = a
			end
		end
	end
	return map
end


local room = function(w, h, wall, floor)
	floor = floor or "blank"
	local map = make(w+2, h+2, floor)
	for x = 1, w+2 do
		for y = 1, h+2 do
			if (x == 1 or x == w+2 or
					y == 1 or y == h+2) then
				map[x][y] = wall
			end
		end
	end
	return map
end


local door = function(map, dx, dy, door)

	dx = math.min(math.max(dx, 2), map.w-1)
	dy = math.min(math.max(dy, 2), map.h-1)


	if math.abs((dx/map.w) - 0.5) < math.abs((dy/map.h) - 0.5) then
		local side = math.floor((dy / map.h) + 0.5)
		dx = (map.w - 1) * side + 1
	else
		local side = math.floor((dx / map.w) + 0.5)
		dy = (map.h - 1) * side + 1
	end

	map[dx][dy] = door
	return map
end


local line = function(map, x1, y1, x2, y2, cell)

	local tx = x2 - map.w
	local ty = y2 - map.h

	if math.abs(tx - x1) < math.abs(x2 - x1) then
		x2 = tx
	end
	if math.abs(ty - y1) < math.abs(y2 - y1) then
		y2 = ty
	end

	local delta_x = x2 - x1
	local ix = delta_x > 0 and 1 or -1
	delta_x = 2 * math.abs(delta_x)

	local delta_y = y2 - y1
	local iy = delta_y > 0 and 1 or -1
	delta_y = 2 * math.abs(delta_y)

	local px = (x1 + map.w - 1) % map.w + 1
	local py = (y1 + map.h - 1) % map.h + 1
	map[px][py] = cell

	if delta_x >= delta_y then
		local err = delta_y - delta_x / 2

		while (math.abs(x1-x2) > 1) do
			if ((err > 0) or (err == 0 and ix > 0)) then
				err = err - delta_x
				y1 = y1 + iy
			end

			err = err + delta_y
			x1 = x1 + ix

			px = (x1 + map.w - 1) % map.w + 1
			py = (y1 + map.h - 1) % map.h + 1
			map[px][py] = cell
		end
	else
		local err = delta_x - delta_y / 2

		while math.abs(y1 - y2) > 1 do
			if ((err > 0) or (err == 0 and iy > 0)) then
				err = err - delta_y
				x1 = x1 + ix
			end
			err = err + delta_x
			y1 = y1 + iy

			px = (x1 + map.w - 1) % map.w + 1
			py = (y1 + map.h - 1) % map.h + 1
			map[px][py] = cell
		end
	end

	return map
end


local road = function(map, x1, y1, x2, y2, r, flip)

	local tx = x2 - map.w
	local ty = y2 - map.h
	if math.abs(tx - x1) < math.abs(x2 - x1) then
		x2 = tx
	end
	if math.abs(ty - y1) < math.abs(y2 - y1) then
		y2 = ty
	end

	local dx = math.min(math.abs(x2-x1), map.w - math.abs(x2-x1))
	local dy = math.min(math.abs(y2-y1), map.h - math.abs(y2-y1))

	local steep = dx < dy and not flip or flip

	local px = (x1 + map.w - 1) % map.w + 1
	local py = (y1 + map.h - 1) % map.h + 1
	map[px][py] = r

	while x1 ~= x2 or y1 ~= y2 do

		if steep then
			if x1 == x2 then
				y1 = y1 + (y1 < y2 and 1 or -1)
			else
				x1 = x1 + (x1 < x2 and 1 or -1)
			end
		else
			if y1 == y2 then
				x1 = x1 + (x1 < x2 and 1 or -1)
			else
				y1 = y1 + (y1 < y2 and 1 or -1)
			end
		end
		local px = (x1 + map.w - 1) % map.w + 1
		local py = (y1 + map.h - 1) % map.h + 1
		map[px][py] = r
	end
	return map
end


local replace = function(map, a, b)
	for x = 1, map.w do
		for y = 1, map.h do
			if map[x][y] == a then
				map[x][y] = b
			end
		end
	end
	return map
end


local grow = function(map, a, n, use8)
	local search = {}
	if use8 then
		search = { {x=1, y=0}, {x=1, y=1}, {x=0, y=1}, {x=-1, y=1}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1}, {x=1, y=-1} }
	else
		search = { {x=1, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=0, y=-1} }
	end
	local nmap = copy(map)
	for x = 1, map.w do
		for y = 1, map.h do
			if nmap[x][y] ~= a then
				local i = 0
				for k, s in pairs(search) do
					local sx = (x+s.x-1) % map.w + 1
					local sy = (y+s.y-1) % map.h + 1
					if (nmap[sx][sy] == a) then
						i = i + 1
					end
				end
				if i >= n then
					map[x][y] = a
				end
			end
		end
	end
	return map
end


local reduce = function(map, a, b, n, use8)
	local search = {}
	if use8 then
		search = { {x=1, y=0}, {x=1, y=1}, {x=0, y=1}, {x=-1, y=1}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1}, {x=1, y=-1} }
	else
		search = { {x=1, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=0, y=-1} }
	end
	local nmap = copy(map)
	for x = 1, map.w do
		for y = 1, map.h do
			if nmap[x][y] == a then
				local i = 0
				for k, s in pairs(search) do
					local sx = (x+s.x-1) % map.w + 1
					local sy = (y+s.y-1) % map.h + 1
					if (nmap[sx][sy] == a) then
						i = i + 1
					end
				end
				if i < n then
					map[x][y] = b
				end
			end
		end
	end
	return map
end


local path = function(map, x1, y1, x2, y2, r, threshold, rng)

	local tx = x2 - map.w
	local ty = y2 - map.h
	if math.abs(tx - x1) < math.abs(x2 - x1) then
		x2 = tx
	end
	if math.abs(ty - y1) < math.abs(y2 - y1) then
		y2 = ty
	end

	local count = math.ceil(math.min(math.abs(x1 - x2), math.abs(y1 - y2) ) / threshold)

	local xdist = (x2 - x1) / count
	local ydist = (y2 - y1) / count

	local startx = x1
	local starty = y1

	for i = 0, count - 1 do
		x1 = startx + xdist * i
		y1 = starty + ydist * i
		x2 = x1 + xdist
		y2 = y1 + ydist

		map = road(map, math.floor(x1 + 0.5), math.floor(y1 + 0.5), math.floor(x2 + 0.5), math.floor(y2 + 0.5), r, rng:random() > 0.5)
	end

	return map

end


local distanceSqr = function(x1, y1, x2, y2, w, h)
	local dx = math.min(math.abs(x2-x1), w - math.abs(x2-x1))
	local dy = math.min(math.abs(y2-y1), h - math.abs(y2-y1))
	return dx * dx + dy * dy
end


local distanceaxis = function(x1, y1, x2, y2, w, h)
	local dx = math.min(math.abs(x2-x1), w - math.abs(x2-x1))
	local dy = math.min(math.abs(y2-y1), h - math.abs(y2-y1))
	return dx, dy
end


local wrap = function(x, y, w, h)
	x = (x + w - 1) % w + 1
	y = (y + h - 1) % h + 1
	return x, y
end


local wrap1 = function(x, w)
	x = (x + w - 1) % w + 1
	return x
end

local getaxisdifference = function(x1, x2, w)
	
	if math.abs(x2 - x1) < w / 2 then
		return x2 - x1
    elseif x2 > x1 then
		return x2 - x1 - w
	end
    return x2 - x1 + w
end


local findnearestaxis = function(x1, y1, x2, y2, w, h)
	
	local dir_x = getaxisdifference(x1, x2, w)
	local dir_y = getaxisdifference(y1, y2, h)
	
	if math.abs(dir_x) > math.abs(dir_y) then
		return dir_x / math.abs(dir_x), 0
	elseif math.abs(dir_y) > math.abs(dir_x) then
		return 0, dir_y / math.abs(dir_y)
	end
	
	return 0, 0
end


local tools = {
	copy = copy,
	make = make,
	pointdiff = pointdiff,
	stencil = stencil,
	cellauto = cellauto,
	clear = clear,
	clearrect = clearrect,
	apply = apply,
	noise = noise,
	room = room,
	door = door,
	line = line,
	road = road,
	replace = replace,
	grow = grow,
	reduce = reduce,
	path = path,
	distanceSqr = distanceSqr,
	distanceaxis = distanceaxis,
	wrap = wrap,
	wrap1 = wrap1,
	getaxisdifference = getaxisdifference,
	findnearestaxis = findnearestaxis
}

return tools
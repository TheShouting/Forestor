local util = require("util")


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


local findClosest = function(samples, pnt, w, h)
	local closest = -1
	local distance = w * w + h * h
	for i, c in pairs(samples) do
		local d = distanceSqr(c.x, c.y, pnt.x, pnt.y, w, h)
		if d < distance then
			distance = d
			closest = i
		end
	end
	return closest
end


local makenearpoint = function(x, y, minr, maxr, rng)

	local a = rng:random() * 2 * math.pi
	local rad = (rng:random() * (maxr - minr)) + minr + 1

	x = x + util.round(math.cos(a) * rad )
	y = y + util.round(math.sin(a) * rad )

	return x, y
end


local makemanhattenpoint = function(x, y, minr, maxr, rng)
	
	local angle = rng:random() * 2 * math.pi
	
    local abs_cos_angle = math.abs(math.cos(angle))
    local abs_sin_angle = math.abs(math.sin(angle))
    
    local magmin = 0
    local magmax = 0
    if abs_sin_angle <= abs_cos_angle then
        magmin = minr / abs_cos_angle
        magmax = maxr / abs_cos_angle
    else
        magmin = minr / abs_sin_angle
        magmax = maxr / abs_sin_angle
    end
    
	local range = rng:random() * (magmax - magmin) + magmin

	local distx = math.cos(angle) * range
	local disty = math.sin(angle) * range

	return util.round(x + distx), util.round(y + disty)
end


local nextpoint = function(samples, gen, w, h, rng)
	local bestCandidate = nil
	local bestDistance = 0
	local parentindex = nil
	for i = 1, gen do
		local a = {x=rng:random(w), y=rng:random(h)}
		local b_i = findClosest(samples, a, w, h)
		local b = samples[b_i]
		local dx = math.min(math.abs(a.x - b.x), math.abs(a.x - b.x - w))
		local dy = math.min(math.abs(a.y - b.y), math.abs(a.y - b.y - h))
		local d = dx*dx + dy*dy
		if (d > bestDistance) then
			bestDistance = d
			bestCandidate = a
			parentindex = b_i
		end
	end
	bestCandidate.neighbors = {parentindex}
	return bestCandidate
end

local centerlevel = function(level)
	
	local offset_x = level[1].x
	local offset_y = level[1].y
	
	for _, node in ipairs(level) do
		node.x = node.x - offset_x
		node.y = node.y - offset_y
	end
	
	return level
	
end

--- Level of random points
local makeLevel = function(w, h, child, gen, rng)

	local tree = {{x=1, y=1, neighbors={}}}

	for i = 2, child+1 do
		local pnt = nextpoint(tree, gen, w, h, rng)
		local parent = tree[pnt.neighbors[1]]
		parent.neighbors[#parent.neighbors+1] = i
		tree[i] = pnt
	end

	tree.w = w
	tree.h = h

	return tree
end


local getFarthest = function(tree)

	local farthest = 1
	local distance = 0
	for i, point in ipairs(tree) do
		local neighbors = point.neighbors
		if #neighbors == 1 then
			local count = 0
			local node = i

			while true do
				n = neighbors[1]
				if n < node then
					neighbors = tree[n].neighbors
					node = n
				else
					break
				end
				count = count+1
			end

			if count > distance then
				distance = count
				farthest = i
			end

		end
	end

	return farthest, distance
end


--- Implementation of Brids algorithm
local brids = function(w, h, child, samples, min, max, rng)

	
	--1. Pick a random point that's already been placed
	--2. Pick a random sample that's near the random point.
	
	
	
	local tree = { {x=1, y=1, size = min, neighbors={}} }
	local available = {1}
	local debug = {}
	
	while #tree <= child and #available > 0 do

		local a_i = rng:random(#available)
		local parent = available[a_i]

		local found = true
		
		--local max_dist = 10000000
		
		for i = 1, samples do
			
			local pnode = tree[parent]
			--local nx, ny = makenearpoint(tree[parent].x, tree[parent].y, min, max, rng)
			local nx, ny = makemanhattenpoint(pnode.x, pnode.y, max - pnode.size, max, rng)
			nx, ny = wrap(nx, ny, w, h)

			--max_dist = math.min(distanceaxis(nx, ny, pnode.x, pnode.y, w, h)) - pnode.size
			
			found = true
			for _, t in pairs(tree) do
				local distx, disty = distanceaxis(nx, ny, t.x, t.y, w, h)
				--if distanceSqr(nx, ny, t.x, t.y, w, h) < min * min then
				
				if distx < (t.size + min) / 2 and disty < (t.size + min) / 2 then
					found = false
					break
				end
			end

			if found then
				local max_dist = w + h
				for _, nt in pairs(tree) do
					local dx, dy = distanceaxis(nx, ny, nt.x, nt.y, w, h)
					local d = math.max(dx * 2 - nt.size, dy * 2 - nt.size)
					max_dist = math.min(d, max_dist)
				end
				
				table.insert(tree, { x=nx, y=ny, size = max_dist, neighbors = {parent} })
				table.insert(tree[parent].neighbors, #tree)
				table.insert(available, #tree)
				break
			end
		end

		if not found then
			--table.insert(debug, parent..":"..max_dist)
			table.remove(available, a_i)
		end

	end

	tree.w = w
	tree.h = h
	tree.debug = debug

	return tree
end

local brids2 = function(w, h, child, samples, min, max, rng)
	
	local tree = { {x=1, y=1, neighbors={}} }
	local available = {1}
	local debug = {}
	
	while #tree <= child and #available > 0 do

		local a_i = rng:random(#available)
		local parent = available[a_i]

		local found = true
		
		local max_dist = 0

		for i = 1, samples do

			local nx, ny = makenearpoint(tree[parent].x, tree[parent].y, min, max, rng)
			
			local dist = rng:random(max - min) + min + 1
			
			local search = {}
			if false then
				search = { {x=1, y=0}, {x=1, y=1}, {x=0, y=1}, {x=-1, y=1}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1}, {x=1, y=-1} }
			else
				search = { {x=1, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=0, y=-1} }
			end
			local vec = search[rng:random(#search)]
			local nx, ny = wrap(vec.x * dist, vec.y * dist, w, h)

			found = true
			for _, t in pairs(tree) do
				local dsqr = distanceSqr(nx, ny, t.x, t.y, w, h)
				max_dist = math.max(max_dist, dsqr)
				if dsqr < min * min then
					found = false
					break
				end
			end

			if found then
				table.insert(tree, { x=nx, y=ny, neighbors={parent} })
				table.insert(tree[parent].neighbors, #tree)
				table.insert(available, #tree)
				break
			end
		end

		if not found then
			table.insert(debug, parent..":"..math.ceil(math.sqrt(max_dist)))
			table.remove(available, a_i)
		end

	end

	tree.w = w
	tree.h = h
	tree.debug = debug

	return tree
end


local partition = function(w, h, samples, min, rng)
	
	
	local tree = { {x=1, y=1, w=w, h=h, neighbors={}} }
	local available = {1}
	
	for i = 1, samples do
		
		local id = available[rng:random(#available)]
		local width = tree[id].w
		local height = tree[id].h
		local x = tree[id].x
		local y = tree[id].y
		
		if width > height then
			if width > min * 2 then
				local diff = math.ceil(width / 2) - min
				local n_width = math.floor((width - diff + rng:random(diff*2)) / 2)
				--tree[id].x = wrap1(x + math.floor(n_width / 2), width)
				tree[id].w = width - n_width
				local new_room = {x = wrap1(x + width - n_width, width), y = y, w = n_width, h = height, neighbors={id}}
				table.insert(tree, new_room)
				table.insert(tree[id].neighbors, #tree)
				table.insert(available, #tree)
			else
				table.remove(available, id)
			end
		else
			if height > min * 2 then
				local diff = math.ceil(width / 2) - min
				local n_height = math.floor((height - diff + rng:random(diff*2)) / 2)
				--tree[id].y = wrap1(y + math.floor(n_height / 2), height)
				tree[id].h = height - n_height
				local new_room = {x = x, y = wrap1(y + height - n_height, height), w = width, h = n_height, neighbors={id}}
				table.insert(tree, new_room)
				table.insert(tree[id].neighbors, #tree)
				table.insert(available, #tree)
			else
				table.remove(available, id)
			end
		end
		
	end
	
	tree = centerlevel(tree)
	
	tree.w = w
	tree.h = h
	tree.debug = {}
	return tree
	
	
end


local levelgen = {
	makeLevel = makeLevel,
	getFarthest = getFarthest,
	brids = brids,
	brids2 = brids2,
	partition = partition
}

return levelgen
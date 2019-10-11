local util = require("util")
local tools = require("gen.tools")


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


local generate = function(level, rng)
	
	local w = level.w
	local h = level.h
	local map = {}
	
	map.loot = {}
	map.spawn = {}
	map.doors = {}

	for i = 1, #level do
		local doors = {}
		
		local x1 = level[i].x
		local y1 = level[i].y
		
		for n_i, n in ipairs(level[i].neighbors) do
			
			local x2 = level[n].x
			local y2 = level[n].y
			local ax, ay = tools.findnearestaxis(x1, y1, x2, y2, w, h)
			
			local dx = tools.wrap1(x1 + util.round(ax * level[i].size * 0.5), w)
			local dy = tools.wrap1(y1 + util.round(ay * level[i].size * 0.5), h)
			
			dx = dx + util.round(tools.getaxisdifference(x1, x2, w) / 2) * math.abs(ay)
			dy = dy + util.round(tools.getaxisdifference(y1, y2, h) / 2) * math.abs(ax)
			
			dx, dy = tools.wrap(dx, dy, w, h)
			
			doors[n_i] = {x=dx, y=dy, destination=n, locked=false}
		end
		map.doors[i] = doors
	end

	return map
end


--- Implementation of Brids algorithm
local brids = function(w, h, child, samples, min, max, rng)

	
	--1. Pick a random point that's already been placed
	--2. Pick a random sample that's near the random point.
	
	local tree = { {x=1, y=1, size = rng:random(min, max), neighbors={}} }
	local available = {1}
	
	while #tree <= child and #available > 0 do

		local a_i = rng:random(#available)
		local parent = available[a_i]

		local found = true
		
		
		for i = 1, samples do
			
			local pnode = tree[parent]
			--local nx, ny = makemanhattenpoint(pnode.x, pnode.y, max - pnode.size, max, rng)
			
			local rdist = rng:random(max - pnode.size, max)
			local nvect = {{x=0, y=1}, {x=1, y=0}, {x=0, y=-1}, {x=-1, y=0}}
			local v = nvect[rng:random(#nvect)]
			local nx = pnode.x + (rdist * v.x) + rng:random(math.floor(pnode.size / -2), math.ceil(pnode.size / 2)) * v.y
			local ny = pnode.y + (rdist * v.y) + rng:random(math.floor(pnode.size / -2), math.ceil(pnode.size / 2)) * v.x
			
			nx, ny = tools.wrap(nx, ny, w, h)
			
			found = true
			for t_i, t in pairs(tree) do
				local distx, disty = tools.distanceaxis(nx, ny, t.x, t.y, w, h)
				if distx < (t.size + min) / 2 and disty < (t.size + min) / 2 then
					found = false
					break
				end
				
				if i ~= parent then
					local midx = (nx - pnode.x) / 2 + nx
					local midy = (ny - pnode.y) / 2 + ny
					
					local d = math.max(distx * 2 - pnode.size, disty * 2 - pnode.size)
					
					distx, disty = tools.distanceaxis(midx, midy, t.x, t.y, w, h)
					
					if distx < d / 2 and disty < d / 2 then
						found = false
						break
					end
				end
			end

			if found then
				local max_dist = w + h
				for _, nt in pairs(tree) do
					local dx, dy = tools.distanceaxis(nx, ny, nt.x, nt.y, w, h)
					local d = math.max(dx * 2 - nt.size, dy * 2 - nt.size)
					max_dist = math.min(d, max_dist)
				end
				
				table.insert(tree, { x=tools.wrap1(nx, w), y=tools.wrap1(ny, h), size = max_dist, neighbors = {parent} })
				table.insert(tree[parent].neighbors, #tree)
				table.insert(available, #tree)
				break
			end
		end

		if not found then
			table.remove(available, a_i)
		end

	end

	tree.w = w
	tree.h = h
	tree.begin = 0
	tree.finish, _ = getFarthest(tree)
	
	generate(tree,rng)

	return tree
end


local levelgen = {
	makeLevel = makeLevel,
	getFarthest = getFarthest,
	brids = brids,
	generate = generate
}

return levelgen
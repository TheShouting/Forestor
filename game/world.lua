-- World handler

-- require("bit32")
local generate = require("gen.generate")
local objects = require("game.objects")
local mapset = require("data.mapset")

local world = {}

world.set = mapset

function world.new(width, height)
	world.width = width or 0
	world.height = height or 0
	world.map = {}
	world.actor = {}
	world.prop = {}
	world.player = {}
	world.time = 0
	
	world.level = 1
	world.seed = 0
	
	world.view = 4
	world.i = 1
	
	world.updatetime = 0
	
	world.transition = -1
	world.transitiontime = 0
	world.transitionmethod = world.generate
	
	local tkeys = {}
	for k, v in pairs(world.set) do
		table.insert(tkeys, k)
	end
	
	for x=1, world.width do
		world.map[x] = {}
		for y=1, world.height do
			world.map[x][y] = { id = "blank", rand = 0, see = false, time = 0, state = "", bitmask = 0 }
		end
	end
	
	world.player = objects.player(100,25)
	world.insert(world.player, 1, 1)

end

function world.generate()

	for i=#world.actor, 2, -1 do
		local actor = world.actor[i]
		local cell = world.map[actor.pos.x][actor.pos.y]
		cell.obj = nil
		world.actor[i] = nil
	end
	
	world.move(world.player, 1, 1)
	world.player.animation = {}
	
	generate.run(world)
	
	--world.flush()
	world.floodview(1, 1, world.view)
	world.player.message = "I see forest..."
end


function world.nextlevel(portal, instigator)

	if instigator == world.player then
		world.level = world.level + 1
		world.transition = 50
		world.transitionmethod = world.generate
	end

end

function world.load(file)

end


function world.propertymap(property)
	local map = {}
	for x = 1, world.width do
		map[x] = {}
		for y = 1, world.height do
			local id = world.map[x][y].id
			map[x][y] = world.set[id][property]
		end
	end
	return map
end


function world.getneighbors(x, y)
	local p = world.pos(x, y)
	local search = { {x=0, y=-1}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=0} }
	local cell = world.map[p.x][p.y]
	local tile = world.set[cell.id]
	local bw = 0
	if tile and tile.neighbors then
		for i, s in ipairs(search) do
			local np = world.pos(s.x+p.x, s.y+p.y)
			local nid = world.map[np.x][np.y].id
			if tile.neighbors[nid] then
				bw = bit.bor(bw, 2^(i-1))
			end
		end
	end
	cell.bitmask = bw
end


function world.makeneighbormap()
	for x = 1, world.width do
		for y = 1, world.height do
			world.getneighbors(x, y)
		end
	end
end


function world.getbitmask(x, y)
	local p = world.pos(x, y)
	if world.map[p.x][p.y].bitmask < 0 then
		world.getneighbors(x, y)
	end
	return world.map[p.x][p.y].bitmask
end

-- Return new position within the map
function world.pos(px, py)
	return { x = ((px - 1) % world.width) + 1, y = ((py - 1) % world.height) + 1 }
end


function world.getTile(x, y)
	local pos = world.pos(x, y)
	local cell = world.map[pos.x][pos.y]
	return world.set[cell.id].tile
end


function world.getState(x, y)
	local pos = world.pos(x, y)
	local cell = world.map[pos.x][pos.y]
	if cell.see then
		return cell.state, cell.time
	end
	return "hidden", cell.time
end


function world.name(x, y)
	local pos = world.pos(x, y)
	local cell = world.map[pos.x][pos.y]
	if (cell.prop) then
		return cell.prop.name
	else
		return world.set[cell.id].name
	end
end


function world.propSprite(x, y)
	local pos = world.pos(x, y)
	local cell = world.map[pos.x][pos.y]
	if (cell.see) then
		if (cell.prop) then
			return cell.prop:getSprite()
		end
	end
	return nil
end

function world.getActor(x, y)
	local p = world.pos(x, y)
	return world.map[p.x][p.y].obj
end

function world.visible(x, y)
	local p = world.pos(x, y)
	return world.map[p.x][p.y].see
end

function world.open(x, y)
	local p = world.pos(x, y)
	local id = world.map[p.x][p.y].id
	return world.set[id].move
end

function world.random(x, y)
	local p = world.pos(x, y)
	return world.map[p.x][p.y].rand
end

function world.key(x, y)
	local p = world.pos(x, y)
	local id = world.map[p.x][p.y].id
	return world.set[id].key
end

-- insert actor in world
function world.insert(obj, x, y)
	local pos = world.pos(x, y)
	if (world.map[pos.x][pos.y].obj == nil) then
		i = #world.actor + 1
		world.actor[i] = obj
		obj.pos = pos
		world.map[pos.x][pos.y].obj = obj
		return i
	else
		return 0
	end
end


function world.setId(x, y, id)
	world.map[x][y].id = id
	world.map[x][y].bitmask = -1
	local search = { {x=0, y=-1}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=0} }
	for _, n in ipairs(search) do
		local p = world.pos(x + n.x, y + n.y)
		world.map[p.x][p.y].bitmask = -1
	end
end

function world.flush()
	for x=1, world.width do
		for y=1, world.height do
			local cell = world.map[x][y]
			cell.see = false
		end
	end
end

function world.fov(vx, vy, range)
	world.map[vx][vy].see  = true
	for x = -range, range do
		for y = -range, range do
			if ((x*x + y*y) < range*range) then
				local p = world.pos(vx+x, vy+y)
				local cell = world.map[p.x][p.y]
				cell.see = world.ray(vx, vy, vx + x, vy + y)
			end
		end
	end
end

function world.floodview(x, y, range, cx, cy)

	if (cx and cy) then
		local r = (cx - x) * (cx - x) + (cy - y) * (cy - y)
		if (r > range*range) then
			return nil
		end
	else
		cx = x
		cy = y
	end

	local s8 = {{1,0}, {1,1}, {0,1}, {-1,1},{-1,0},{-1,-1},{0, -1},{1, -1}}

	for k, v in pairs(s8) do
		local nx = v[1] + cx
		local ny = v[2] + cy
		local pos = world.pos(nx, ny)
		local cell = world.map[pos.x][pos.y]
		local check = not cell.see

		cell.see = true

		if (world.set[cell.id].see and check) then
			world.floodview(x, y, range, nx, ny)
		end
	end

end

function world.path(ox, oy, tx, ty)

	local s4 = { {x=1, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=0, y=-1} }

	local npath = {x=0, y=0}
	local dist = world.width * world.width + world.height * world.height + 10
	for i = 1, #s4 do
		local dir = s4[i]
		local pos = world.pos(dir.x + ox,dir.y + oy)
		local cell = world.map[pos.x][pos.y].id
		if (world.set[cell].move) then
			local dx = math.min( math.abs(tx - pos.x), math.abs(tx + world.width - pos.x))
			local dy = math.min( math.abs(ty - pos.y), math.abs(ty + world.height - pos.y))
			if (dx*dx + dy*dy < dist) then
				dist = dx*dx + dy*dy
				npath = dir
			end
		end
	end

	return npath
end

function world.dist(x1, y1, x2, y2)
	local p1 = world.pos(x1, y1)
	local p2 = world.pos(x2, y2)

	local x = math.min( math.abs(p1.x - p2.x), world.width - math.abs(p1.x - p2.x))
	local y = math.min( math.abs(p1.y - p2.y), world.height - math.abs(p1.y - p2.y))

	return x * x + y * y
end

function world.ray(x1, y1, x2, y2)

	local tx = y2 - world.width
	local ty = y2 - world.height

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

	if delta_x >= delta_y then
		local err = delta_y - delta_x / 2

		while (math.abs(x1-x2) > 1) do
			if ((err > 0) or (err == 0 and ix > 0))
				then
				err = err - delta_x
				y1 = y1 + iy
			end

			err = err + delta_y
			x1 = x1 + ix

			local pos = world.pos(x1, y1)
			local cell = world.map[pos.x][pos.y]
			if (not world.set[cell.id].see) then
				return false
			end
		end
	else
		local err = delta_x - delta_y / 2

		while math.abs(y1 - y2) > 1 do
			if ((err > 0) or (err == 0 and iy > 0))
				then
				err = err - delta_y
				x1 = x1 + ix
			end
			err = err + delta_x
			y1 = y1 + iy

			local pos = world.pos(x1, y1)
			local cell = world.map[pos.x][pos.y]
			if (not world.set[cell.id].see) then
				return false
			end
		end
	end

	return true
end


-- Move object in world
function world.move(obj, x, y)
	local npos = world.pos(x, y)
	local newcell = world.map[npos.x][npos.y]

	if (newcell.obj == nil) then
		local pos = obj.pos
		local oldcell = world.map[pos.x][pos.y]
		oldcell.obj = nil
		newcell.obj = obj
		obj.pos = npos

		if (world.set[oldcell.id].leave) then
			oldcell.id = world.set[oldcell.id].leave
		end

		return nil
	else
		local mo = world.map[npos.x][npos.y].obj
		if (mo ~= obj) then
			return mo
		else
			return nil
		end
	end
end


-- move actor across the map
function world.shift(obj, x, y, t, dist)

	dist = dist or 1

	local anim = {
		pos = {x=obj.pos.x, y=obj.pos.y},
		dir = {x=x, y=y},
		lerp = "bump",
		state = "move"
	}

	obj.anim[#obj.anim + 1] = anim

	for i = 1, dist or 1 do

		local pos = world.pos(obj.pos.x + x, obj.pos.y + y)
		local cell = world.map[pos.x][pos.y]
		local id = cell.id

		if (world.set[id].hit) then
			local k = world.set[id].key
			if k then
				if obj.active then
					if obj:usekey(k) then
						world.setId(pos.x, pos.y, world.set[id].hit)
					else
						obj.message = "I need "..k.."!"
					end
				end
			else
				world.setId(pos.x, pos.y, world.set[id].hit)
			end
		end

		if (world.set[id].move) then
			local oldpos = obj.pos

			local hit = world.move(obj, pos.x, pos.y)

			if not hit then
				cell.time = t
				world.map[oldpos.x][oldpos.y].time = t
				cell.state = "walk"
				anim.lerp = obj.active and "step" or "slide"
				anim.dir = {x=x*i, y=y*i}

				if cell.prop then
					if cell.prop.auto then
						obj:pickup(cell)
					end
				end
			else
				return hit, i-1
			end
		else
			if cell.prop and obj.active then
				obj:pickup(cell)
			end
			cell.time = t
			cell.state = "hit"
			return true, i-1
		end
	end
	return nil, dist
end


function world.fademap(n)

	n = n or 1

	local player = world.player.pos

	for i=1, n do
		local rx = love.math.random( -world.view - 1, world.view + 1)
		local ry = love.math.random( -world.view - 1,  world.view + 1)

		local pos = world.pos(player.x + rx, player.y + ry)

		world.map[pos.x][pos.y].see = false
	end

	world.map[player.x][player.y].see  = true
end


function world.revealmap(t)
	for x = -world.view - 1, world.view + 1 do
		for y = -world.view - 1, world.view + 1 do
			local pos = world.pos( world.player.pos.x + x, world.player.pos.y + y)
			world.map[pos.x][pos.y].time = t
			world.map[pos.x][pos.y].state = "reveal"
		end
	end
end


function world.loot(container, other)
	other.loot = container
end


function world.addcorpse(actor)

	local corpse = objects.dummy("portal", world.loot)

	corpse.left = actor.left
	corpse.right = actor.right

end



-------------------------------------------------
-- Game update method ---------------------------
-------------------------------------------------

function world.input(x, y)
	controller.playerinput = {x=x, y=y}
end

function world.update(time)
	if world.transition < 0 then
		world.iterate(time)
	else
		if world.transition == 0 then
			world.transition = - 1
			world.transitionmethod()
			world.revealmap(time)
			return
		end

		if time - world.transitiontime > 0 then
			world.fademap(10)
			world.transition = world.transition - 1
			world.transitiontime = time
		end
	end
end

function world.iterate(time)

	local actor = world.actor[world.i]

	local taken = world.taketurn(actor, time)

	if taken then
		if world.i == 1 then
			local px = actor.pos.x
			local py = actor.pos.y
			world.flush()
			world.map[px][py].see = true
			world.floodview(px, py, world.view)
		end

		actor.memdmg = 0
		actor.updateTime = time
		actor.active = false
		if #actor.anim > 0 then
			actor.animation = actor.anim
			actor.anim = {}
		end

		world.i = world.i + 1

		if world.i > #world.actor then
			world.i = 1
		end

	end
end



function world.taketurn(actor, time)

	-- get knockback from actors equipment
	local rkb = 0
	if actor.right then
		if actor.right.integrity <= 0 then
			actor.right = nil
		else
			rkb = actor.right.knockback or 0
		end
	end

	local lkb = 0
	if actor.left then
		if actor.left.integrity <= 0 then
			actor.left = nil
		else
			lkb = actor.left.knockback or 0
		end
	end

	actor.knockback = math.max(rkb, lkb)

	-- update actor
	local cell =
	world.map[actor.pos.x][actor.pos.y]
	if (actor.alive) then
		-- move and update actor
		local move = actor:update(world)

		if not move then
			return false -- stop if waiting on input
		end

		if (move.x == 0 and move.y == 0) then

			if actor.active then
				local anim = {
					pos = {x=actor.pos.x, y=actor.pos.y},
					dir = {x=0, y=0}
				}

				cell.time = time
				if cell.prop then
					actor:pickup(cell)
					anim.lerp = "step"
				end
				actor.anim[#actor.anim + 1] = anim
			end
		else
			local other, _ = world.shift(actor,move.x,move.y,time)
			if type(other) == "table" and actor.active then
				other:push(actor)
				other.time = time

				-- knock back pushed actor
				if actor.knockback > 0 then
					if other.alive and not other.heavy then
						local _, d = world.shift(other, move.x, move.y, time, actor.knockback)
						if d > 0 then
							other:setstatus("stun", 1)
						end
					end
				end
			end
		end
		-- Apply tile effects
		local ncell = world.map[actor.pos.x][actor.pos.y]
		local effect = world.set[ncell.id].effect
		if (effect) then
			actor.time = time
			for e, t in pairs(effect) do
				actor.status[e] = t
			end
		end

	else
		if (actor.rot == 0) then
			local prop = actor:die(world)
			if (not cell.prop) then
				cell.prop = prop
			end
			cell.obj = nil
			table.remove(world.actor, world.i)
			world.i = world.i - 1
		else
			actor.animation = {}
			actor.rot = actor.rot - 1
		end
	end

	return true
end


return world


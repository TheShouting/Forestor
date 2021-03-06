local controller = require("game.controller")

local entity = require("game.objects.entity")

-- actor class --------------------------
local actor = {}
actor.__index = actor
setmetatable(actor, {
	__index = entity,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})


function actor:_init(id)
	entity._init(self, id)
	self.alive = true
	self.rot = 10
	self.thinkeffects = {}
	self.memdmg = 0
end


function actor:pickup(cell)
	local prop = cell.prop
	if prop and self.hands then
		if not prop.consume then
			if (self[prop.hand]) then
			  cell.prop = self[prop.hand]
			else
			  cell.prop = nil
			end
			self[prop.hand] = prop
			
			self.message = "I have "..prop.name.."!"
		else
			self.message = "I take "..prop.name.."!"
			cell.prop = nil
		end
				   
		prop:onpickup(self)
	else
		self.message = "There's nothing there."
	end
   
end


function actor:setcontroller(t, c)
	table.insert(self.thinkeffects, {t, c})
end


function actor:push(other)
	if self.alive then
		other:attack(self)
	else
		other.loot = self
	end
end


function actor:attack(other)
   
	local dmg = -1
	
	local str = self.str
	
	if self.right then
		self.right:hitother(self, other)
		if self.right.dmg then
			local req = self.right:getval("req")
			
			if str >= req then
				dmg = love.math.random(0, str - req) + self.right:getval("dmg")
			else
				if love.math.random(0, req - str) == 0 then
					dmg = love.math.random(0, str) + self.right:getval("dmg")
				end
			end
		end
	else
		dmg = love.math.random(-1, str)
	end
	
	if dmg >= 0 then
		self.message = "I hit "..other:getName().." for "..dmg.." dmg"
		other:defend(dmg, self)
	else
		self.message = "I missed "..other:getName()
	end
end


function actor:defend(dmg, other)

	if self.left then
		if self.left.def then
			local def = self.left.getval("def")
			dmg = math.max(dmg - def, 0)
			self.left:use()
			-- maybe add a scale value where its
			-- only partially used if low dmg
		end
	end
	
	self:dmg(dmg)
end


function actor:dmg(dmg)
   
	self.hp = self.hp - dmg
	self.memdmg = -dmg
	
	if (self.hp <= 0) then
		self.alive = false
	end
	self.status.hit = 1
   
end

function actor:heal(amt)
	self.hp = self.hp + amt
	self.memdmg = amt
end

function actor:setstatus(s, n)
	local stat = self.status[s]
	if stat then
		self.status[s] = math.max(stat, n)
	else
		self.status[s] = n
	end
end


function actor:update(world)
	self.message = nil
	--self.memdmg = 0
	
	for e, val in pairs(self.status) do
		if (val > 0) then
			self.status[e] = val - 1
		else
			self.status[e] = nil
		end
	end
	
	local action = nil
	if not self.status.stun then
		if #self.thinkeffects > 0 then
			self.active = true
			local i = #self.thinkeffects
			local think = self.thinkeffects[i][1]
			action = controller[think](self, world)
			local c = self.thinkeffects[i][2] - 1
			if c > 0 then
				self.thinkeffects[i][2] = c
			else
				table.remove(self.thinkeffects)
			end
		elseif self.think then
			self.active = true
			action = controller[self.think](self, world)
		end
	else
		action = {x=0, y=0}
	end
	
	return action
end


function actor:die()
	-- Drop a random item if an actor dies
	local items = {}
	if (self.left) then
		table.insert(items, self.left)
	end
	if (self.right) then
		table.insert(items, self.right)
	end
	if (#items > 0) then
		return items[love.math.random(#items)]
	else
		return nil
	end
end


function actor:haskey(key)
	if key then
		if (self.right) then
			if self.right.key == key then
				return true
			end
		end
		if (self.left) then
			if self.left.key == key then
				return true
			end
		end
		return false
	end
	return true
end


function actor:usekey(key)
	if key then
		if (self.right) then
			if self.right:usekey(key) then
				return true
			end
		end
		if (self.left) then
			if self.left:usekey(key) then
				return true
			end
		end
		return false
	end
	return true
end


function actor:col()
	local color = {196,0,0}
	if (self.alive) then
		for k, v in pairs(self.color) do
			color[k] = v
		end
		
		if (self.status.wet) then
			color.sin = {64, 196, 255}
		end
		
		if (self.status.hit) then
			color.blink = {255, 32, 32}
		end
	
	end
	color.time = self.time
	return color
end

function actor:getName()
	if self.alive then
		return self.name
	end
	return "corpse"
end


return actor
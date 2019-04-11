local cut = function(attacker, defender)
   defender:setstatus("wet", 5)
end

local terrify = function(attacker, defender)
   defender:setcontroller("flee", 5)
end

local destroy = function(attacker, defender)
   if love.math.random() > 0.5 then
      local opt = {}
      if defender.right then
         opt[#opt+1] = defender.right
      end
      if defender.left then
         opt[#opt+1] = defender.left
      end
      
      if #opt > 0 then
			      local r = love.math.random(#opt)
			      opt[r].broken = true
      end
   end
end

local drain = function(attacker, defender)
   
end

local hit = {
   cut=cut,
   terrify=terrify
   }

return hit
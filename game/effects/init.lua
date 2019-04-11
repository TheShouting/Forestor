local hit = require("game.effects.hit")

--positive effects

local war = function(prop)
   prop.effects.war = true
   prop.valeffects.war = {dmg = 2, def = 0.5}
   return prop
end

local deadly = function(prop)
   prop.effects.deadly = true
   prop.hiteffects.deadly = hit.cut
   return prop
end

local terrifying = function(prop)
   prop.effects.terrifying = true
   prop.hiteffects.terrifying = hit.terrify
   return prop
end


-- negative effects

local heavy = function(prop)
   prop.effects.heavy = true
   prop.valeffects.heavy = {req=1.5}
   return prop
end

local broken = function(prop)
   prop.effects.broken = true
   return prop
end

local brittle = function(prop)
   prop.effects.brittle = true
   prop.valeffects.brittle = {degrade=2}
   return prop
end


local effects = {
      war = war,
      deadly = deadly,
      terrifying = terrifying,
      heavy = heavy,
      broken = broken,
      brittle = brittle
   }
   
return effects

local heal = function(actor, prop)
    actor.hp = actor.hp + prop.val
end


local consume = {
   heal = heal
   }
   
return consume
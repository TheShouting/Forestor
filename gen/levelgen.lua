local distanceSqr = function(x1, y1, x2, y2, w, h)
   local dx =
      math.min(math.abs(x2-x1), math.abs(x2-x1-w))
   local dy = 
      math.min(math.abs(y2-y1), math.abs(y2-y1-h))
   return dx * dx + dy * dy
end


local findClosest = function(samples, pnt, w, h)
  local closest = -1
  local distance = w * w + h * h
  for i, c in pairs(samples) do
			  local d = 
			     distanceSqr(c.x, c.y, pnt.x, pnt.y, w, h)
			  if d < distance then
			     distance = d
			     closest = i
			  end
  end
  return closest
end


local nextpoint=function(samples, gen, w, h, rng)
   local bestCandidate = nil
   local bestDistance = 0
   local parentindex = nil
   for i = 1, gen do
      local a = 
         {x=rng:random(w), y=rng:random(h)}
      local b_i = findClosest(samples, a, w, h)
      local b = samples[b_i]
      local dx = math.min(
         math.abs(a.x - b.x), 
         math.abs(a.x - b.x - w))
      local dy = math.min(
         math.abs(a.y - b.y), 
         math.abs(a.y - b.y - h))
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
			         local neighborfound = false
			         local lowest = node
			         for _, n in pairs(neighbors) do
			            if n < lowest then
			               lowest = n
			               neighborfound = true
			               neighbors =
			                  tree[node].neighbors
			            end
			         end
			         if neighborfound then
			            node = lowest
			            count = count+1
			         else
			            break
			         end
			      end
			      
			      if count > distance then
			         distance = count
			         farthest = i
			      end
			      
      end
   end
   
   return farthest
end


local levelgen = {
	makeLevel = makeLevel,
	getFarthest = getFarthest
	}

return levelgen
local distanceSqr = function(x1, y1, x2, y2, w, h)
   local dx =math.min(
      math.abs(x2-x1),
      w - math.abs(x2-x1))
   local dy = math.min(
      math.abs(y2-y1),
      h - math.abs(y2-y1))
   return dx * dx + dy * dy
end

local wrap = function(x, y, w, h)
   x = (x + w - 1) % w + 1
   y = (y + h - 1) % h + 1
   return x, y
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


local makenearpoint = 
   function(x, y, minr, maxr, rng)

   local a = rng:random() * 2 * math.pi
   local rad = rng:random() * (maxr-minr) + minr
   
   x = x + math.floor(math.cos(a) * rad + 0.5)
   y = y + math.floor(math.sin(a) * rad + 0.5)
   
   return x, y
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


local brids = 
   function(w, h, child, samples, min, max, rng)

			local tree = {{x=1, y=1, neighbors={}}}
			local available = {1}
			
			while #tree <= child and #available > 0 do
			
			   local a_i = rng:random(#available)
			   local parent = available[a_i]
			
			   local found = true
			
			   for i = 1, samples do
			      
			      local nx, ny = makenearpoint(
			         tree[parent].x, tree[parent].y, 
			         min, max, rng)
			      nx, ny = wrap(nx, ny, w, h)
			      
			      for _, t in pairs(tree) do
   			      if distanceSqr(nx,ny,t.x,t.y,w,h)
   			         < min * min then
   			         found = false
   			         break
   			      end
			      end
			      
			      if found then
			         table.insert(tree,
			            {x=nx, y=ny, neighbors={parent}})
			         table.insert(
			            tree[parent].neighbors, #tree)
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
			
			return tree
end



local levelgen = {
	makeLevel = makeLevel,
	getFarthest = getFarthest,
	brids = brids
	}

return levelgen
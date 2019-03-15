--module("mymath", package.seeall)

local mapgen = {}

function mapgen.generate(w, h, seed)

   -- My very hacky level generation
   local trees = mapgen.make(w, h, "grass")
   mapgen.noise(trees, 0.65, "tree")
   
   local nx = math.ceil(w * 0.125)
   local ny = math.ceil(h * 0.125)
   local nw = math.ceil(w * 0.25)
   local nh = math.ceil(h * 0.25)
   local x1 = love.math.random(nw) - nx
   local y1 = love.math.random(nh) - ny
   local x2 = x1 + love.math.random(nw) - nx
   local y2 = y1 + love.math.random(nh) - ny
   local x3 = x2 + love.math.random(nw) - nx
   local y3 = y2 + love.math.random(nh) - ny
   mapgen.road(trees, 1, 1, x1, y1, "grass", 2)
   mapgen.road(trees, x1, y1, x2, y2, "grass", 2)
   mapgen.road(trees, x2, y2, x3, y3, "grass", 2)
   for i=1, 3 do
      mapgen.cellauto(trees, "tree", "grass")
   end
   mapgen.clear(trees, 1, 1, 3, "grass")
   
   local ground = mapgen.make(w, h, "dirt")
   mapgen.noise(ground, 0.35, "tallgrass")
   for i=1, 3 do
      mapgen.cellauto(
         ground, "tallgrass", "dirt")
   end
   mapgen.apply(ground, trees, 1, 1, "grass")
   
   local map = mapgen.make(w, h, "dirt")
   mapgen.noise(map, 0.65, "grass")
   for i=1, 2 do
      mapgen.cellauto(map, "grass", "dirt")
   end
   mapgen.apply(map, ground, 1, 1, "dirt")
   
   mapgen.road(map, 1, 1, x1, y1, "path", 1)
   mapgen.road(map, x1, y1, x2, y2, "path", 1)
   mapgen.road(map, x2, y2, x3, y3, "path", 1)
   
   local room = mapgen.room(3, 3, "wall", "dirt", "doorclose")
   
   mapgen.apply(map, room, -8, -8)
   return map
end

function mapgen.make(w, h, fill)

   local map = {w=w, h=h}

   for x = 1, w do
      map[x] = {}
      for y = 1, h do
         map[x][y] = fill
      end
   end
   
   return map
end

function mapgen.cellauto(map, a, b)

   s8 = {{1,0}, {1,1}, {0,1}, {-1,1},
        {-1,0},{-1,-1},{0, -1},{1, -1}}

   local nmap = mapgen.make(map.w, map.h, b)
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

function mapgen.clear(m, cx, cy, size, c)

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

function mapgen.clearrect(map, x, y, r, c)

   local r1 = math.floor(r*0.5 + 0.5)
   local r2 = math.ceil(r*0.5 - 0.5) - 1
   
   
   for w = -r1, r2 do
      for h = - r1, r2 do
         local px = (x + w - 1) % map.w + 1
         local py = (y + h - 1) % map.h + 1
         map[px][py] = c
      end
   end

end

function mapgen.apply(map, stamp, sx, sy, a)

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

end


function mapgen.noise(map, n, a)
   for x=1, map.w do
      for y=1, map.h do
         if (love.math.random() < n) then
            map[x][y] = a
         end
      end
   end
   return map
end


function mapgen.room(w, h, wall, floor, door)

   floor = floor or "blank"

   local map = mapgen.make(w+2, h+2, floor)

   for x = 1, w+2 do
      for y = 1, h+2 do
         if (x == 1 or x == w+2 or 
            y == 1 or y == h+2) then
            map[x][y] = wall
         end
      end
   end
   
   if not door then
      door = floor
   end
   
   local side = love.math.random(2) - 1
   if love.math.random() < 0.5 then
      local dx = (w + 1) * side + 1
      local dy = love.math.random(h) + 1
      map[dx][dy] = door
   else
      local dx = love.math.random(w) + 1
      local dy = (h + 1) * side + 1
      map[dx][dy] = door
   end
   
   return map

end

function mapgen.line(map, x1, y1, x2, y2, cell)

   local tx = y2 - map.w
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
         if ((err > 0) or (err == 0 and ix > 0))
         then
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
         if ((err > 0) or (err == 0 and iy > 0))
         then
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

end


function mapgen.road(map, x1, y1, x2, y2, r, t)

   local tx = y2 - map.w
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
   
   mapgen.clearrect(map, x1, y1, t, r)
   
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
         
         mapgen.clearrect(map, x1, y1, t, r)
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
         
         mapgen.clearrect(map, x1, y1, t, r)
      end
   end
end


   
return mapgen





mapgen = {}


function generate(w, h, seed)

   -- My very hacky level generation
   local final = mapgen.make(w, h, "tree")
   mapgen.noise(final, 0.25, "treesmall")
   mapgen.noise(final, 0.1, "stump")
   
   local tmap =
      mapgen.cellauto(w, h, "tree", "dirt", 3, 0.5)
   
   tmap = maogen.apply(final, tmap, "tree")
      
   mapgen.clear(tmap, 1, 1, 3, "dirt")
   
   local cmap = 
      mapgen.cellauto(w, h, "cliff", "dirt", 3, 0.35)
   mapgen.clear(cmap, 1, 1, 8, "dirt")
      
   local gmap = 
      mapgen.cellauto(w, h, "grass", "dirt", 2, 0.5)
   local bmap =
      mapgen.cellauto(w, h, "tallgrass", "dirt", 2, 0.4)
   local wmap = 
      mapgen.cellauto(w, h, "puddle", "dirt", 1, 0.5)
      
   final = make(w, h, "grass")
   mapgen.noise(final, 0.05, "flower")
   mapgen.noise(final, 0.01, "stump")
   gmap = mapgen.apply(final, gmap, "grass")
      
   final = mapgen.apply(wmap, gmap, "dirt")
   final = mapgen.apply(final, bmap, "dirt")
   final = mapgen.apply(final, tmap, "dirt")
   final = mapgen.apply(final, cmap, "dirt")
   
   final = mapgen.room(final, -5, -5, 5, 5, "wall", "dirt")

   return final

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

function mapgen.apply(a, b, alpha)

   local map = mapgen.make(a.w, a.h, alpha)

   for x=1, a.w do
      for y=1, a.h do
         if (b[x][y] == alpha) then
            map[x][y] = a[x][y]
         else
            map[x][y] = b[x][y]
         end
      end
   end
   return map
end

function mapgen.cellauto(w, h, a, b, gen, noi)

   local map = make(w, h, b)
   mapgen.noise(map, noi, a)

   s8 = {{1,0}, {1,1}, {0,1}, {-1,1},
        {-1,0},{-1,-1},{0, -1},{1, -1}}
   
   for i=1, gen do
      prime = map
      map = mapgen.make(w, h, b)
      for x=1, w do
         for y=1, h do
            local n = 0
            
            for k, s in pairs(s8) do
               local sx = (x + s[1] - 1) % w + 1
               local sy = (y + s[2] - 1) % h + 1
               if (prime[sx][sy] == a) then
                  n = n + 1
               end
            end
            
            if (prime[x][y] == a and n >= 4)
            then
               map[x][y] = a
            end
            if (prime[x][y] == b and n >= 5)
            then
               map[x][y] = a
            end
         end
      end
   end

   return map
end

function mapgen.clear(m, cx, cy, size, c)

   for x=-size, size do
      for y=-size, size do
         local px = (cx + x - 1) % m.w + 1
         local py = (cy + y - 1) % m.h + 1
         m[px][py] = c
      end
   end
   return m

end

function mapgen.noise(map, n, a)
   for x=1, map.w do
      for y=1, map.h do
         if (love.math.random() < n) then
            map[x][y] = a
         end
      end
   end
end

function mapgen.room(map, rx, ry, rw, rh, wall, floor)

   for x = 1, rw do
      for y = 1, rh do
         local px = (rx + x - 1) % map.w
         local py = (ry + y - 1) % map.h
         if (x == 1 or x == rw or 
            y == 1 or y == rh) then
            map[px][py] = wall
         else
            map[px][py] = floor
         end
      end
   end
   local px = (rx + rh - 1) % map.w
   local py = 
      (ry + math.floor(rh / 2 + 0.5) - 1) % map.h
   map[px][py] = "doorclose"
   return map

end

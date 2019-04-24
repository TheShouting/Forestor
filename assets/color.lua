local color = {

   default = {180, 210, 120},
   warm = {210, 180, 120},
   cool = {120, 210, 180},
   highlight = {255, 255, 255},
   shadow = {0, 0, 0},
   
   
   getColor = function(self, col)
      if not self[col] then
         col = "default"
      end
      local c = {}
      for k, v in pairs(self[col]) do
         c[k] = v
      end
      return c
   end
}


return color
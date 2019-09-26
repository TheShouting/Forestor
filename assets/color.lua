local color = {

   highlight = {255, 255, 255},
   shadow = {0, 0, 0},
   green = {180, 210, 120},
   brown = {210, 180, 120},
   blue= {120, 210, 180},
   stone = {196, 196, 196},
   
   
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
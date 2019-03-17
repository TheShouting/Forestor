local tileset = {}


local load = function(self, file, w, h)

   self[file] = {}

   local img = love.graphics.newImage(
      "assets/img/"..file..".png")
      
   img:setFilter( "linear", "nearest" )
      
   self[file].img = img
   self[file].tile = {}
   
   local imgw, imgh = img:getDimensions()
   
   local tw = math.floor(imgw / w)
   local th = math.floor(imgh / h)
   
   local i = 0
   for y = 0, th-1 do
     for x = 0, tw-1 do
     
        i = i + 1
        
        self[file].tile[i] =
           love.graphics.newQuad(
           x * w, y * h, w, h, imgw, imgh )
     
     end
  end
  
  return self[file]
   
end



tileset = {load = load}
   
return tileset
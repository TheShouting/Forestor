local imagehandler = {}

imagehandler.__index = imagehandler
setmetatable(imagehandler, {
   __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function imagehandler:_init(...)

   self.scale = 3

   self.sheets = {}
   
   for i=1, select("#",...) do
      local file = select(i,...)
      local img = love.graphics.newImage(
         "assets/img/"..file..".png")
      img:setFilter( "linear", "nearest" )
      self.sheets[file] = img
   end

end


function imagehandler:drawtile(x, y, tile,
   bitmask, rval, scale)

   local sheet = self.sheets[tile.sheet]

   local img = tile.images[1]
   if tile.bitmask then
      img = tile.images[bitmask+1]
   else
      rval = math.floor(rval)
      img = tile.images[rval % #tile.images + 1]
   end
   
   local quad = love.graphics.newQuad(
            img[1], img[2], img[3], img[4], 
            sheet:getWidth(), sheet:getHeight() )
   
   love.graphics.draw(sheet, quad, x, y, 
      0, scale, scale, 0, 0)
end





return imagehandler
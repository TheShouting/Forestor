require("widget")

game = {}

game.__index = game
setmetatable(game,{
   __index = widget.base,
   __call = function (cls, ...)
			   local self = setmetatable({}, cls)
			   self:_init(...)
			   return self
   end,
})

function game:_init(...)
   widget.base._init(self, ...)
			self.tilew = 30
			self.tileh = 60
			self.off = {x = 0, y = 0 }
			self.range = 4
end

function game:enter() 

   
end

function game:update(dt)

   local pos = world.player.pos
   local dx = math.abs(self.off.x - pos.x)
   local dy = math.abs(self.off.y - pos.y)
   if (dx >= self.range) then
      self.off.x = pos.x
   end
   if (dy >= self.range) then
      self.off.y = pos.y
   end

end

function game:draw()

   local dt = self.timer - world.timer
   
   local tw = self.tilew * 3
   local th = self.tileh
   
   local vw =
      math.floor((self.w / tw) * 0.5)
   local vh = 
      math.floor((self.h / th) * 0.5)
   local bx = 
      (self.w - vw*2*tw) * 0.5
   local by = 
      (self.h - vh*2*th) * 0.5
   
   for x=1, vw*2 do
      for y=1, vh*2 do
         
         local wx = x + self.off.x - vw
         local wy = y + self.off.y - vh
         local col = world.col(wx, wy)
         
         col = util.processcolor(col, dt)
         
         local char = world.char(wx, wy)
         
         local cx = x * tw + self.x - tw + bx
         local cy = y * th + self.y - th + by
            
         util.drawtile(
            cx, cy, char, col, tw / 3, th, true)
      end
   end
end



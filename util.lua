local util = {}

function util.copy(t)
   local ct = {}
   for k, v in pairs(t) do
      ct[k] = v
   end
   return ct
end

function util.lumin(c)
   return (c[1]*0.3 + c[2]*0.59 + c[3]*0.11) / 255
end

function util.lerprgb(a, b, t)
   local r = a[1] + (b[1] - a[1]) * t
   local g = a[2] + (b[2] - a[2]) * t
   local b = a[3] + (b[3] - a[3]) * t
   return {r, g, b}
end


function util.processcolor(color, t, offset)

   offset = offset or 0
   
   local ncol = color
   if (color.ember) then
      local v = math.sin((t+offset)* 8)*0.5+0.5
      ncol = util.lerprgb(color.ember, ncol, v)
   end
   if (color.sin) then
      t = love.timer.getTime()
      local v = math.sin(t*6) * 0.5 + 0.5
      ncol = util.lerprgb(color.sin, ncol, v)
   end
   if (color.fsin) then
      local v = math.sin(t*24) * 0.5 + 0.5
      ncol = util.lerprgb(color.fsin, ncol, v)
   end
   if (color.blink) then
      local dt = t - color.time
      local v = math.min(dt * 2, 1)
      ncol = util.lerprgb(color.blink, ncol, v)
   end
   if (color.fade) then
      local dt = t - color.time
      local v = math.min(dt * 0.5, 1)
      ncol = util.lerprgb(color.fade, ncol, v)
   end
   
   return ncol
end


function util.drawmessage(msg, x, y, c, pad, dt)

   local scroll = math.min(dt * 4, 1)
   nmsg = string.sub(msg, 1, 
      math.floor(#msg * scroll) - #msg - 1)

   local a = math.min(dt * 0.33, 1)
   local col = {c[1], c[2], c[3], 255 - 255*a}
   local tpad = pad*2
   local f = love.graphics.getFont()
   local w = f:getWidth(msg) * scroll
   local h = f:getHeight()
   love.graphics.setColor(0,0,0, col[4])
   love.graphics.rectangle(
      "fill", x, y, w + tpad, h + tpad)
   love.graphics.setColor(col)
   love.graphics.rectangle(
      "line", x, y, w + tpad, h + tpad)
   love.graphics.print(nmsg, x+pad, y+pad)
end


function util.drawtile(x, y, char, col, k, l, glow)
   if glow then
      --local lum = util.lumin(col)
			   local a = 0.1
			   love.graphics.setColor(
			      col[1]*a, col[2]*a, col[3]*a)
			   love.graphics.rectangle(
			      "fill", x, y, k*3, l)
			   a=0.2
			   love.graphics.setColor(
			     col[1]*a, col[2]*a, col[3]*a)
			   love.graphics.ellipse(
			      "fill", x+k*1.5, y+l*0.5, k*1.5, l*0.5)
			   a=0.35
			   love.graphics.setColor(
			      col[1]*a, col[2]*a, col[3]*a)
			   love.graphics.ellipse(
			      "fill", x+k*1.5, y+l*0.5, k, l*0.333)
   end
         
   love.graphics.setColor(col)
         
   for i=1, #char do
      cx = x + k*(i-1)
      love.graphics.print(char:sub(i,i), cx, y)
   end
end


function util.drawglow(c, x, y, w, h)
   local lum = util.lumin(c)
		 local a = 48
		 love.graphics.setColor(c[1], c[2], c[3], a)
		 --love.graphics.rectangle("fill", x, y, w, h)
			--a=0.2
			love.graphics.setColor(c[1], c[2], c[3], a)
		 love.graphics.ellipse(
			   "fill", x+w*0.5, y+h*0.5, w*0.5, h*0.5)
			--a=0.35
		 love.graphics.setColor(c[1], c[2], c[3], a)
		 love.graphics.ellipse(
			   "fill", x+w*0.5, y+h*0.5, w*0.33, h*0.33)
         
   love.graphics.setColor(c)
         
end


return util
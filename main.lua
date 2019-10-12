-- A simple Löve2D roguelike game

require("util")
local scene = require("scene.menuscene")
--local scene = require("scene.gamescene")

-------------------------------------------------
-- Main Program ---------------------------------
-------------------------------------------------

local app = nil
local scale = 2

-- computer runs GLSL ES 1.0 (what is uniform distortion)
local crt_shader
local draw_shader
local buffer


local screen_w, screen_h

function love.load()
	
	crt_shader = love.graphics.newShader[[
    vec4 effect(vec4 color, Image tx, vec2 tex_coord, vec2 screen_coord)
	{
		float distortion = 0.1;
		float aberration = 1.1;
		
		// curvature
		vec2 cc = tex_coord - 0.5;
		float dist = dot(cc, cc) * distortion;
		tex_coord = (tex_coord + cc * (1.0 + dist) * dist);
		
		// fake chromatic aberration
		float sx = aberration / love_ScreenSize.x;
		float sy = aberration / love_ScreenSize.y;
		vec4 r = Texel(tx, vec2(tex_coord.x + sx, tex_coord.y - sy));
		vec4 g = Texel(tx, vec2(tex_coord.x, tex_coord.y + sy));
		vec4 b = Texel(tx, vec2(tex_coord.x - sx, tex_coord.y - sy));
		number a = (r.a + g.a + b.a) / 3.0;

		number _r = r.r;
		number _g = g.g;
		number _b = b.b;

		return vec4(_r, _g, _b, a);
	}
	]]

	draw_shader = love.graphics.newShader[[
	    vec4 effect(vec4 color, Image tx, vec2 tex_coord, vec2 screen_coord)
		{
			vec4 pixel = Texel(tx, tex_coord);
			return vec4(pixel.r, pixel.r, pixel.r, pixel.a) * color;
		}
	]]


	local imgf = love.graphics.newImageFont(
		"woods_font_1x.png",
		" abcdefghijklmnopqrstuvwxyz"..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ"..
		"1234567890-=!@#$%^&*()_+"..
		"[]\\;'.,/{}|:\"<>?`~", 1)
	love.graphics.setFont(imgf)

	love.graphics.setColor(255,255,255)
	love.graphics.setBackgroundColor(0,0,0)


	screen_w, screen_h = love.graphics.getDimensions()

	scale = math.max(math.floor(screen_h / 300), 1)
	--scale = 1

	app = scene()
	app:startScene(scale)

	app.debugmsg = screen_w..", "..screen_h.." - "..scale
	
	buffer = love.graphics.newCanvas(screen_w, screen_h)
	
	love.graphics.setBlendMode( 'alpha', 'alphamultiply' )
	
end


function love.touchpressed(id, x, y, pressure)
	app:input(x, y)
end


function love.touchreleased(id, x, y, pressure)
end


function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		app:goback()
	else
		app:presskey(key)
	end
end


function love.update(dt)
	local nextapp = app:updateScene(dt)
	if nextapp then
		if nextapp ~= app then
			if app.quit then app:quit() end
			app = nextapp
			app.newscene = app
			app:startScene(scale)
		end
	else
		love.event.quit()
	end
end


function love.draw()

	love.graphics.setShader(draw_shader)
	app:drawScene()
	
	
	love.graphics.setCanvas(buffer)
	love.graphics.setShader()
	
	
	love.graphics.setColor(0, 0, 0, 72)
	love.graphics.rectangle( 'fill', 0, 0, screen_w, screen_h )
	
	love.graphics.setBlendMode( 'lighten', 'premultiplied' )
	love.graphics.setColor(255,255,255)
	love.graphics.draw(app.canvas, 0, 0, 0, scale)
	
	love.graphics.setBlendMode( 'alpha', 'alphamultiply' )
	love.graphics.setCanvas()
	love.graphics.setShader(crt_shader)
	love.graphics.draw(buffer, 0, 0, 0, 1)
	love.graphics.setShader()

end


function love.quit()
	if app.quit then
		app:quit()
	end
end





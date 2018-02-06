function drawStuff ()

	local w = love.graphics.getWidth()
		local h = love.graphics.getHeight()
		local totalRatio = screenResolution[1]/screenResolution[2]
		ww = h*totalRatio
		if ww>w then
		while ww>w do
			ww=ww-0.1
		end
		hh=ww/totalRatio
		else hh = h end
		sx = ww/screenResolution[1]
		sy = hh/screenResolution[2]
		yy = (1-(hh/h))/2*h
		xx = (1-(ww/w))/2*w

		love.graphics.setBlendMode('alpha', 'alphamultiply')

		love.graphics.setBackgroundColor(backgroundColor)

		love.graphics.draw(awesomecanvas,xx,yy,0,sx,sy)


	--[[temporarilyhere, this below
			love.graphics.setFont(randomfont)
			love.graphics.setColor(0,0,0,255)
	    love.graphics.print(printMeThis, 10, 10)
			love.graphics.setColor(255,255,255,255)]]

end

return drawStuff

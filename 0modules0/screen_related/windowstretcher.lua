function windowstretchess ()

	if windowstretch == 0 then
		local w = love.graphics.getWidth()
   		local h = love.graphics.getHeight()
   		sy = math.floor(h/768)
   		sx = math.floor(w/1024)
  		yy = (1-(768/h))/2*h
   		xx = (1-(1024/w))/2*w 
    	love.graphics.draw(awesomecanvas, xx, yy, 0, sx, sy)
			
		if map.current~=0 then
		local mapstable = require ("maps."..map.current.."."..map.current)
    	cam:setBounds(0, 0, mapstable.width*m-1024/sx,mapstable.height*m-768/sy)
		end

   	end
   	if windowstretch == 1 then
   		local w = love.graphics.getWidth()
 		local h = love.graphics.getHeight()
   		sx = w/1024
   		sy = h/768
    	love.graphics.draw(awesomecanvas, 0, 0, 0, sx, sy)
    	local mapstable = require ("maps."..map.current.."."..map.current)
		cam:setBounds(0, 0, mapstable.width*m-ww/sx,mapstable.height*m-hh/sy)
   	end

   	if windowstretch == 2 then
		local w = love.graphics.getWidth()
   		local h = love.graphics.getHeight()
   		local arvar = 1024/768
   		ww = h*arvar
   		if ww>w then
			while ww>w do
				ww=ww-0.1
			end
			hh=ww/arvar
   		else hh = h end
   		sx = ww/1024
   		sy = hh/768
  		yy = (1-(hh/h))/2*h
   		xx = (1-(ww/w))/2*w 
    	love.graphics.draw(awesomecanvas,xx,yy,0,sx,sy)
    	local mapstable = require ("maps."..map.current.."."..map.current)
	    cam:setBounds(0, 0, mapstable.width*m-ww/sx,mapstable.height*m-hh/sy)
   	end	
end

return windowstretchess

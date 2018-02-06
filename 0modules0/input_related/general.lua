function general (dt)
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end

	if love.keyboard.isDown("f11") and keyf11pressed == false then
		keyf11pressed = true
		if fullscren==false then
			local a  = love.graphics.getWidth()
			local b = love.graphics.getHeight()
			love.window.setMode( a, b, {fullscreen =true,
			fullscreentype="desktop", vsync=true,msaa=0,resizable = true,
			borderless = false,centered = true, display = 1,minwidth=0,
			minheight=0,highdpi=false} )
			fullscren=true
		elseif fullscren==true then
			love.window.setMode( screenResolution[1], screenResolution[2], {fullscreen =false,
			fullscreentype="desktop", vsync=true,msaa=0,resizable = true,
			borderless = false,centered = true, display = 1,minwidth=0,
			minheight=0,highdpi=false} )
			fullscren=false
		end
	end

	if love.keyboard.isDown("f11") == false and keyf11pressed == true then
		keyf11pressed = false
	end



	if love.mouse.isDown(1)==true and leftmousePressed == false then
		leftmousePressed = true
		local clickedX, clickedY = love.mouse.getPosition()

		clickedX = clickedX/sx-xx/sx
		clickedY = clickedY/sy-yy/sy

		for aHotspot = 1, #Slide[currentSlide].hotspot, 1 do

			if clickedX >= Slide[currentSlide].hotspot[aHotspot].x1 and
			clickedX <= Slide[currentSlide].hotspot[aHotspot].x2 and
			clickedY >= Slide[currentSlide].hotspot[aHotspot].y1 and
			clickedY <= Slide[currentSlide].hotspot[aHotspot].y2 then

				clickedHotspot = aHotspot
				local noHotspot = true

				for oneOfImg = 1, #Slide[currentSlide].img, 1 do


					local testingForExplosions = false
					if Slide[currentSlide].img[oneOfImg].explode[1] ~= nil then
						for mineTest = 1, #Slide[currentSlide].img[oneOfImg].explode, 1 do
							if Slide[currentSlide].img[oneOfImg].explode[mineTest] == clickedHotspot then
								testingForExplosions = true
								break
							end
						end
					end

					if testingForExplosions == true then
						noHotspot = false
						slowlyChangingToTheNextSlide = true
						img[oneOfImg].animating = true
					end

				end


				if noHotspot == true then
					newSlide(Slide.hotspot[currentSlide][aHotspot].nextSlide)
					clickedHotspot = 0
				end
				break

			end

		end

		--detect hotspots here...
	end

	if love.mouse.isDown(1) == false and leftmousePressed == true then
		leftmousePressed = false
	end

	if Slide[currentSlide].img[1] ~= nil and img[1] ~= nil then

		for sumImg = 1, #Slide[currentSlide].img, 1 do

			if img[sumImg].animating == true then
				if img[sumImg].delayTimerStarted == false then
					img[sumImg].delayTimerStarted = true
				else
					img[sumImg].delayTimerCount = img[sumImg].delayTimerCount +1
				end

				if img[sumImg].delayTimerCount >= Slide[currentSlide].img[sumImg].animationDelay then
					img[sumImg].delayTimerCount = 0
					img[sumImg].delayTimerStarted = false

					if img[sumImg].currentFrame ~= #img[sumImg].frames then
						img[sumImg].currentFrame = img[sumImg].currentFrame + 1
					else

						if Slide[currentSlide].sfx[1]~= nil then
							for checkinSounds = 1, #Slide[currentSlide].sfx, 1 do
								for checkinFurther = 1, #Slide[currentSlide].sfx[checkinSounds].explode, 1 do
									if Slide[currentSlide].sfx[checkinSounds].explode[checkinFurther] == sumImg then
										love.audio.play(sfx[checkinSounds])
									end
								end
							end
						end


						local testingForExplosions = false
						if Slide[currentSlide].img[sumImg].explode[1] ~= nil then
							for mineTest = 1, #Slide[currentSlide].img[sumImg].explode, 1 do
								if Slide[currentSlide].img[sumImg].explode[mineTest] == clickedHotspot then
									testingForExplosions = true
									break
								end
							end
						end

						if slowlyChangingToTheNextSlide == true and
						testingForExplosions == true then --clickedHotspot
							--cycles through all the images to see if it's the only one left to explode
							local someStillLeft = false --is true if some are still left to explode
							for explodedImg = 1, #Slide[currentSlide].img, 1 do

								local testForExplosions = false
								if Slide[currentSlide].img[explodedImg].explode[1] ~= nil then
									for mineTest = 1, #Slide[currentSlide].img[explodedImg].explode, 1 do
										if Slide[currentSlide].img[explodedImg].explode[mineTest] == clickedHotspot then
											testForExplosions = true
											break
										end
									end
								end
								if testForExplosions == true and --change this to clickedHotspot and need a for loop to check for it
								img[explodedImg].exploded == false then
									someStillLeft = true
									break
								end
							end
							if someStillLeft == true then
								img[sumImg].exploded = true
							else
								slowlyChangingToTheNextSlide = false
								newSlide(Slide[currentSlide].hotspot[clickedHotspot].nextSlide)
								clickedHotspot = 0
								break
							end
							--if so then change to the next slide
						else
							if Slide[currentSlide].img.repeating == true then
								img[sumImg].currentFrame = 1
							else
								img[sumImg].animating = false
								img[sumImg].currentFrame = 1
							end
						end
					end
				end
			end
		end
	end

	drawElements()

end

return general

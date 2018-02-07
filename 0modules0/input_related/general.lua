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

	if Slide[currentSlide].cutsceneTimer.turnOnTimer == true and cutsceneTimerCount ~= -1 then
		cutsceneTimerCount = cutsceneTimerCount + 1
		if cutsceneTimerCount >= Slide[currentSlide].cutsceneTimer.frameCount then
			newSlide(Slide[currentSlide].cutsceneTimer.nextSlide)
			cutsceneTimerCount = -1
		end
	end

	if fadeOutTimerStarted == true then
		fadeOutTimerCount = fadeOutTimerCount + 1
		fadeOutTransparency = fadeOutTransparency + fadeOutRate
		if fadeOutTransparency <0 then fadeOutTransparency=0 end
		if fadeOutTimerCount >= fadeOutTimerRing then
			newSlide(theNextChosenSlide)
			fadeOutTimerStarted=false
		end
	end

	if fadeInTimerStarted == true then

		fadeInTimerCount = fadeInTimerCount + 1
		fadeInTransparency = fadeInTransparency - fadeInRate
		if fadeInTransparency <0 then fadeInTransparency=0 end
		if fadeInTimerCount >= fadeInTimerRing then
			fadeInTimerStarted=false
		end
	end


--------get the x and y coordinates of the cursor-------------------------------
	clickedX, clickedY = love.mouse.getPosition()

	clickedX = clickedX/sx-xx/sx
	clickedY = clickedY/sy-yy/sy
--------------------------------------------------------------------------------

if love.mouse.isDown(1)==true then
--if cursor clicks, play the clickety click animation
if cursorAnimation.click.frames[1] ~= nil then
	if cursorAnimation.nowAnimating ~= "click" then
		cursorAnimation.nowAnimating = "click"
		if cursorAnimation.delayTimerStarted == false then
			cursorAnimation.delayTimerStarted = true
			cursorAnimation.delayTimerCount = 0
			cursorAnimation.currentFrame = 1
		end
	else
		cursorAnimation.delayTimerCount = cursorAnimation.delayTimerCount + 1

		local delay = defaultAnimationDelayForSprites
		if cursorAnimationDelay.click[cursorAnimation.currentFrame] ~= nil then
			delay = cursorAnimationDelay.click[cursorAnimation.currentFrame]
		end

		if cursorAnimation.delayTimerCount >= delay then
			cursorAnimation.delayTimerCount = 0
			if cursorAnimation.currentFrame < #cursorAnimation.click.frames then
				cursorAnimation.currentFrame = cursorAnimation.currentFrame + 1
			else
				cursorAnimation.currentFrame = 1
			end
		end

	end
	love.mouse.setCursor(cursorAnimation.click.frames[cursorAnimation.currentFrame])
end
--------------------------
end



		for aHotspot = 1, #Slide[currentSlide].hotspot, 1 do

			if clickedX >= Slide[currentSlide].hotspot[aHotspot].x1 and
			clickedX <= Slide[currentSlide].hotspot[aHotspot].x2 and
			clickedY >= Slide[currentSlide].hotspot[aHotspot].y1 and
			clickedY <= Slide[currentSlide].hotspot[aHotspot].y2 then

				if love.mouse.isDown(1)==true and leftmousePressed == false then
					leftmousePressed = true
					local canContinue = false

				if Slide[currentSlide].hotspot[aHotspot].onlyActivatesOnImgClick ~= 0 then

					local imgNumber = Slide[currentSlide].hotspot[aHotspot].onlyActivatesOnImgClick
					local frameNumber = img[imgNumber].currentFrame
					local imgWidth = img[imgNumber].frames[frameNumber]:getWidth()
					local imgHeight = img[imgNumber].frames[frameNumber]:getHeight()

					if clickedX >= Slide[currentSlide].img[imgNumber].x and
					clickedX < Slide[currentSlide].img[imgNumber].x+imgWidth and
					clickedY >= Slide[currentSlide].img[imgNumber].y and
					clickedY < Slide[currentSlide].img[imgNumber].y+imgHeight then
						local locationX = clickedX-Slide[currentSlide].img[imgNumber].x
						local locationY = clickedY-Slide[currentSlide].img[imgNumber].y
						print("x "..locationX)
						print("y "..locationY)
						local imgData = love.image.newImageData("sprites/"..Slide[currentSlide].img[imgNumber].folder.."/"..frameNumber..".png")
					local	r,g,b,a = imgData:getPixel( locationX, locationY)
						if a == 255 then
							canContinue = true
						end

					end
				else
					canContinue = true
				end

					if canContinue == true then

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
					newSlide(Slide[currentSlide].hotspot[aHotspot].nextSlide)
					clickedHotspot = 0
				end
				break
				end

			else--if not pressed but above a hotspot

				if cursorAnimation.highlight.frames[1] ~= nil and love.mouse.isDown(1)==false then
					if cursorAnimation.nowAnimating ~= "highlight" then
						cursorAnimation.nowAnimating = "highlight"
						if cursorAnimation.delayTimerStarted == false then
							cursorAnimation.delayTimerStarted = true
							cursorAnimation.delayTimerCount = 0
							cursorAnimation.currentFrame = 1
						end
					else
						cursorAnimation.delayTimerCount = cursorAnimation.delayTimerCount + 1

						local delay = defaultAnimationDelayForSprites
						if cursorAnimationDelay.highlight[cursorAnimation.currentFrame] ~= nil then
							delay = cursorAnimationDelay.click[cursorAnimation.currentFrame]
						end

						if cursorAnimation.delayTimerCount >= delay then
							cursorAnimation.delayTimerCount = 0

							if cursorAnimation.currentFrame < #cursorAnimation.highlight.frames then
								cursorAnimation.currentFrame = cursorAnimation.currentFrame + 1
							else
								cursorAnimation.currentFrame = 1
							end
						end

					end
					love.mouse.setCursor(cursorAnimation.highlight.frames[cursorAnimation.currentFrame])
				end
			end


		else--if not over a hotspot

			if cursorAnimation.normal.frames[1] ~= nil and love.mouse.isDown(1)==false then
				if cursorAnimation.nowAnimating ~= "normal" then
					cursorAnimation.nowAnimating = "normal"
					if cursorAnimation.delayTimerStarted == false then
						cursorAnimation.delayTimerStarted = true
						cursorAnimation.delayTimerCount = 0
						cursorAnimation.currentFrame = 1
					end
				else
					cursorAnimation.delayTimerCount = cursorAnimation.delayTimerCount + 1

					local delay = defaultAnimationDelayForSprites
					if cursorAnimationDelay.normal[cursorAnimation.currentFrame] ~= nil then
						delay = cursorAnimationDelay.normal[cursorAnimation.currentFrame]
					end

					if cursorAnimation.delayTimerCount >= delay then
						cursorAnimation.delayTimerCount = 0
						if cursorAnimation.currentFrame < #cursorAnimation.normal.frames then
							cursorAnimation.currentFrame = cursorAnimation.currentFrame + 1
						else
							cursorAnimation.currentFrame = 1
						end
					end

				end
				love.mouse.setCursor(cursorAnimation.normal.frames[cursorAnimation.currentFrame])
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

				local delay = defaultAnimationDelayForSprites
				if Slide[currentSlide].img[sumImg].animationDelay[img[sumImg].currentFrame] ~= nil then
					delay = Slide[currentSlide].img[sumImg].animationDelay[img[sumImg].currentFrame]
				end

				if img[sumImg].delayTimerCount >= delay then
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
							if Slide[currentSlide].img[sumImg].repeating == true then
								img[sumImg].currentFrame = 1
								img[sumImg].animating = true
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

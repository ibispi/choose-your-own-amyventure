function starterpack ()
--------------------------------------------------------------------------------
	img = {}
	sfx = {}
	music = {}
	hotspot = {}
	text = {}
	source = nil

	trackIsAlreadyPlaying = {}

	fadeOutTransparency = 0

	love.graphics.setFont(textFont)

	currentSlide = 1
	slowlyChangingToTheNextSlide = false --this is true in case some animations
	--have to explode
	clickedHotspot = 0

	fadeOutTimerStarted = false
	fadeOutTimerCount = 0

	love.window.setTitle(windowTitle)


	--loads cursor sprites
	local folders = love.filesystem.getDirectoryItems("cursor")
	cursorAnimation = { normal = {}, highlight = {}, click ={}, currentFrame=1,
	nowAnimating="normal", delayTimerCount = 0, delayTimerStarted = false}
	cursorAnimation.normal = { frames = {}, frameDelay ={},}
	cursorAnimation.highlight = { frames = {}, frameDelay ={},}
	cursorAnimation.click = { frames = {}, frameDelay ={},}

	local cursorTypes = {"normal", "highlight", "click"}
	for i = 1, #folders, 1 do

		for cursorType = 1, #cursorTypes, 1 do

			if folders[i] == cursorTypes[cursorType] then

				local files = love.filesystem.getDirectoryItems("cursor/"..folders[i])

				local highestNumber = 0

				for q = 1, #files, 1 do

					if files[q] ~= nil then

						local thisNumber = files[q]:gsub(".png", "")

						if thisNumber ~= "" then

							thisNumber = tonumber(thisNumber)

							if thisNumber > highestNumber then
								highestNumber = thisNumber
							end
						end
					end
				end

				if highestNumber ~= 0 then

					for aCursor = 1, highestNumber, 1 do
						cursorAnimation[cursorTypes[cursorType]].frames[aCursor] =
						love.mouse.newCursor("cursor/"..folders[i].."/"..aCursor..".png",
						cursorHotspots[cursorTypes[cursorType]].x,
						cursorHotspots[cursorTypes[cursorType]].y )
					end
				end

			end
		end

	end



	function loadSlides()
		local files = love.filesystem.getDirectoryItems("slides")

		local highestNumber = 0

		for i = 1, #files, 1 do


			if files[i] ~= "0template0.lua" then

				if files[i] ~= nil then

					thisNumber = files[i]:gsub(".lua", "")

					if thisNumber ~= "" then

						thisNumber = tonumber(thisNumber)

						if thisNumber > highestNumber then
							highestNumber = thisNumber
						end
					end
				end
			end
		end

		if highestNumber ~= 0 then

			for aSlide = 1, highestNumber, 1 do
				Slide[aSlide] = require("slides/"..aSlide)
			end
		end

		newSlide(1)
	end

	cutsceneTimerCount = -1

	fadeOutColor = {0,0,0}
	theFadeOutColor = startingFadeInColor
	gameStarted = true
	fadeOutRate=1
	theNextChosenSlide = 0

	fadeInTimerStarted=false
	fadeInTimerCount = 0
	fadeInTimerRing = startingFadeInTime

	function newSlide (numero)

		local theTimer = 0
		if gameStarted == false and clickedHotspot~=0 then
			theTimer = Slide[currentSlide].hotspot[clickedHotspot].fadeOutTimer
		end

		if cutsceneTimerCount ~= 0 then
			theTimer = 1
		end


		if gameStarted ~= true and fadeOutTimerStarted ==false and theTimer~=0 then

			if cutsceneTimerCount ~= 0 then

				fadeOutTimerStarted = true
				fadeOutTimerCount = 0
				fadeOutTimerRing = Slide[currentSlide].cutsceneTimer.fadeOutTimer/2
				fadeOutTimerRing = math.floor(fadeOutTimerRing)
				theFadeOutColor = Slide[currentSlide].cutsceneTimer.fadeOutColor
				fadeOutTransparency = 0
				fadeOutRate = 255/fadeOutTimerRing
				theNextChosenSlide = Slide[currentSlide].cutsceneTimer.nextSlide
				cutsceneTimerCount=-1

			else
			fadeOutTimerStarted = true
			fadeOutTimerCount = 0
			fadeOutTimerRing = Slide[currentSlide].hotspot[clickedHotspot].fadeOutTimer/2
			fadeOutTimerRing = math.floor(fadeOutTimerRing)
			theFadeOutColor = Slide[currentSlide].hotspot[clickedHotspot].fadeOutColor
			fadeOutTransparency = 0
			fadeOutRate = 255/fadeOutTimerRing
			theNextChosenSlide = Slide[currentSlide].hotspot[clickedHotspot].nextSlide
			end

		else

			if (fadeOutTimerRing ~= 0 and fadeOutTimerStarted == true) or gameStarted == true then

				fadeInTimerStarted = true
				fadeInTimerCount = 0
				fadeInTransparency = 255
				fadeInRate = 255/fadeInTimerRing
			end
			cutsceneTimerCount = 0
			gameStarted=false
		slowlyChangingToTheNextSlide = false --this is true in case some animations
		--have to explode
		clickedHotspot = 0
		currentSlide = numero

		img = {}

		local folders = love.filesystem.getDirectoryItems("sprites")

		for t = 1, #folders do

			local highestNumber = 0

			for someImg = 1, #Slide[currentSlide].img, 1 do

				if Slide[currentSlide].img[someImg].folder == folders[t] then

				local files = love.filesystem.getDirectoryItems("sprites/"..folders[t])

					for i = 1, #files, 1 do

						local thisNumber = files[i]:gsub(".png", "")

						--it shouldn't check if it is a directory but if it is a png file
						if thisNumber ~= nil then

							thisNumber = tonumber(thisNumber)

							if thisNumber > highestNumber then
								highestNumber = thisNumber
							end

						end
					end

				if highestNumber ~= 0 then

					img[someImg] = { frames = {}, currentFrame = 1, animating = false,
					exploded = false, delayTimerCount = 0, delayTimerStarted = false}
					for anImg = 1, highestNumber, 1 do
						img[someImg].frames[anImg] =
						love.graphics.newImage("sprites/"..folders[t].."/"..anImg..".png")
					end
					if Slide[currentSlide].img[someImg].static == false then
						img[someImg].animating = true
					end
				end
			end
			end
		end

		if Slide[currentSlide] ~= nil then
			if Slide[currentSlide].music ~= nil then
				if Slide[currentSlide].music[1] ~= nil then



							for currentMusic = 1, #Slide[currentSlide].music, 1 do

								local canPlayMusiq = true

								if trackIsAlreadyPlaying[currentSlide]==nil then
									trackIsAlreadyPlaying[currentSlide] = {}
								end

								if Slide[currentSlide].music[currentMusic].startFirstTimeOnly == true then
									if trackIsAlreadyPlaying[currentSlide][currentMusic] == nil then
										trackIsAlreadyPlaying[currentSlide][currentMusic] = true
									else
										canPlayMusiq = false
									end

								end

								if canPlayMusiq == true then

									local songName = "music/"..Slide[currentSlide].music[currentMusic].name..".ogg"
									local source = love.audio.newSource( songName, 'stream' )
									if Slide[currentSlide].music[currentMusic].clear == true then
										love.audio.stop()
									end
									if Slide[currentSlide].music[currentMusic].repeating == true then
										source:setLooping(true)
									end
									love.audio.play(source)
								end

							end
						end

					end
				end


		sfx = {}

		if Slide[currentSlide] ~= nil then
			if Slide[currentSlide].sfx ~= nil then
				if Slide[currentSlide].sfx[1] ~= nil then
					for currentMusic = 1, #Slide[currentSlide].sfx, 1 do
						local songName = "sfx/"..Slide[currentSlide].sfx[currentMusic].name..".ogg"
						local source = love.audio.newSource( songName, 'static' )
						sfx[currentMusic] = source
					end
				end
			end
		end
		end
	end

	function drawElements ()

		love.graphics.setCanvas(awesomecanvas)
		love.graphics.clear()

		if Slide[currentSlide] ~= nil then
			if Slide[currentSlide].img ~= nil then
				if Slide[currentSlide].img[1] ~= nil and img[1]~=nil then
					for currentImg = 1, #Slide[currentSlide].img, 1 do
						local tempX = math.floor(Slide[currentSlide].img[currentImg].x)
						local tempY = math.floor(Slide[currentSlide].img[currentImg].y)
						love.graphics.draw (img[currentImg].frames[img[currentImg].currentFrame], tempX, tempY)
					end
				end
			end
		end

		if Slide[currentSlide] ~= nil then
			if Slide[currentSlide].text ~= nil then
				if Slide[currentSlide].text[1] ~= nil then
					for currentText = 1, #Slide[currentSlide].text, 1 do
						local tempX = math.floor(Slide[currentSlide].text[currentText].x)
						local tempY = math.floor(Slide[currentSlide].text[currentText].y)
						love.graphics.setColor(Slide[currentSlide].text[currentText].color)
						love.graphics.printf(Slide[currentSlide].text[currentText].print,
						tempX, tempY,
						Slide[currentSlide].text[currentText].width, 'center')
					end
				end
			end
		end

		love.graphics.setColor(255,255,255,255)

		if fadeOutTimerStarted == true then
			love.graphics.setColor(theFadeOutColor[1],theFadeOutColor[2],theFadeOutColor[3],fadeOutTransparency)
			love.graphics.rectangle('fill', 0, 0, screenResolution[1], screenResolution[2])
			love.graphics.setColor(255,255,255,255)
		end

		if fadeInTimerStarted == true then
			love.graphics.setColor(theFadeOutColor[1],theFadeOutColor[2],theFadeOutColor[3],fadeInTransparency)
			love.graphics.rectangle('fill', 0, 0, screenResolution[1], screenResolution[2])
			love.graphics.setColor(255,255,255,255)
		end

		love.graphics.setCanvas()
	end
--------------------------------------------------------------------------------
--SPRITE_RELATED
	--sprite.register = require "0modules0.sprite_related.spriteRegister"
	--spritesregistered = require "0modules0.sprite_related.spritelist"
	--tween = require "0modules0.0libraries0.tween.tween"
	windowstretching = require "0modules0.screen_related.windowstretcher"
	drawStuff = require "0modules0.screen_related.drawStuff"

	general = require "0modules0.input_related.general"

	keyf11pressed = false
	leftmousePressed = false

--------------------------------------------------------------------------------
	canDraw=false
	sx=1 sy=1 xx=0 yy=0 ww=0 hh=0
--------------------------------------------------------------------------------
local a  = love.graphics.getWidth()
local b = love.graphics.getHeight()

	if fullScreen == true then
		love.window.setMode( a, b, {fullscreen =true, fullscreentype="desktop",
		vsync=true,msaa=0,resizable = true,borderless = false,centered = true,
		display = 1,minwidth=1,minheight=1,highdpi=false} )
	else
		love.window.setMode( screenResolution[1], screenResolution[2], {fullscreen =false, fullscreentype="desktop",
		vsync=true,msaa=0,resizable = true,borderless = false,centered = true,
		display = 1,minwidth=1,minheight=1,highdpi=false} )
	end

	fullscren=fullScreen

	awesomecanvas = love.graphics.newCanvas(screenResolution[1], screenResolution[2])
	awesomecanvas:setFilter("nearest", "nearest")
	love.graphics.setDefaultFilter( "nearest", "nearest", 8 )

	Slide = {}

--------------------------------------------------------------------------------
end
return starterpack

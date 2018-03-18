--scene_game.lua
--start the game, send the meteors, add the ability to touch and destroy the meteors, 
--and have the ability to destroy the planet

local composer = require( "composer" )
 
local scene = composer.newScene()

local widget = require "widget"
widget.setTheme("widget_theme_ios")

user = loadsave.loadTable("user.json")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local background
local meteor = {}
local meteorCounter = 0
local meteorSendSpeed = 40
local meteorMaxSendSpeed = 17
local meteorIncrementSendSpeed = 0.5
local sendMeteorsListener
local meteorFlashTrans

local meteorTravelSpeed

local meteorTravelSpeedFactor = 60 --higher is slower
local meteorIncrementTravelSpeedFactor = 0.3
local meteorMaxTravelSpeedFactor = 30
local prevId = {}

local tmr_sendMeteors
local btn_pauseRestart

local sendMeteorsCounter = 0

local parent

local streak = 0
local bestStreak = 0

local explosion

local moneyText
local earthHole

local pauseButton
local pauseGame = false
local pauseBackground
local btn_pauseToMenu
local pauseText
local pauseTextInfo
local pauseMenuSoundToggle
local pauseBestScore

local startingHealth = 4
local health = startingHealth
local money

local shoot = true

local shootTimer = 0
local incrementShootTimerListener
--local shootTimerImage 
--shootTimerImageMarker is global

local rocketReloadTimeFactor = 60
local rocketReloadTime = 60 - rocketReloadTimeFactor

--special effects
local plusOne = {}
local plusOneCounter = 0

--forward declare functions
local planetHit
local sendMeteors
local onGameOver


local meteorsDestroyedTextTop, meteorsDestroyedText, meteorsDestroyedTextBottom, gameOverBestScoreText
local pauseBackgroundOverlay

local score = 0

local targetX
local targetY

local explosion = {}
local explosionCounter = 0
local explosionSheetData = {width = 42.125, height = 45, numFrames = 8, sheetContentWidth = 337, sheetContentHeight = 45}
local explosionSheet = graphics.newImageSheet("images/gamescreen/explosionSheet.png", explosionSheetData)
local explosionSequenceData = {
	{name = "explosion", start = 1, count = 8, time = 575, loopCount = 1}
}
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
--starting health
--meteor speed 	meteorTravelSpeed = distanceBetween(meteor[meteorCounter], planet)*meteorTravelSpeedFactor
--meteorTravelSpeedFactor = 20


-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen


local function distanceBetween( pos1, pos2 )
	local factor = { x = pos2.x - pos1.x, y = pos2.y - pos1.y }
	return math.sqrt( ( factor.x * factor.x ) + ( factor.y * factor.y ) )
end

 local function listenerForSetUsername(event)
            if(event.isError) then
                native.showAlert( "Could not send Data", event.error, {"Ok"} )
            else
                native.showAlert( "Data sent", user.username, {"Ok"} )
            end

      end


local function meteorTouched(event)
	if(shootTimer>= rocketReloadTime) then
		shootTimer = 0

		-- shootTimerImageMarker.height = 0
		-- transition.to(shootTimerImageMarker, {height = 113, time = rocketReloadTime*17})

		if(event.phase == "began") then


			local obj = event.target
			local x = event.target.x
			local y = event.target.y
			local id = event.target.id

			for i=1,#prevId do
				--print(id.."  "..prevId[i])
				if(prevId[i] ~= id ) then --or prevId[i] == nil
					shoot = true
				else
					shoot = false
					break
				end
			end

		if shoot == true then

			meteor[event.target.id].alpha = 0.2

			meteorFlashTrans = transition.to(meteor[event.target.id], {alpha = 1, time = 1000})

			table.insert(prevId, event.target.id)

			local function checkAngle(obj1, obj2)
				return math.ceil(math.atan2( (obj1.y - obj2.y), (obj1.x - obj2.x) ) * 180 / math.pi)
			end
			--send the rocket
			-- local rocket = display.newImage("images/gamescreen/rocket.png")
			-- rocket.x = centerX; rocket.y = centerY;
			-- rocket:scale(0.005, 0.005)
			-- sceneGroup:insert(rocket)

			-- rocket.rotation = checkAngle(rocket, event.target) - 90

			-- local rocketTime = 1000--*(distanceBetween(event.target, planet)/200)

			local laser = display.newLine(centerX, centerY, event.target.x, event.target.y)
			laser:setStrokeColor(1, 0, 0)
			laser.width = 3

			local function blowUpMeteor() 

				transition.cancel ( event.target.trans )
				timer.performWithDelay(300, function() display.remove(laser) end)

			 -- 	plusOne[plusOneCounter] = display.newImage(sceneGroup, "images/gamescreen/plusOne.png")
				-- plusOne[plusOneCounter].x = x
				-- plusOne[plusOneCounter].y = y-20
				-- plusOne[plusOneCounter].alpha = 1
				-- plusOne[plusOneCounter]:scale(0.35, 0.35)
				-- plusOne[plusOneCounter].trans = transition.to(plusOne[plusOneCounter], {alpha = 0, y = plusOne[plusOneCounter].y-20, time = 400, onComplete = function() display.remove(plusOne[plusOneCounter]) end})
				-- sceneGroup:insert(plusOne[plusOneCounter])
				-- plusOneCounter = plusOneCounter+1
				
				display.remove( obj )

				explosion[explosionCounter] = display.newSprite(explosionSheet, explosionSequenceData)
					explosion[explosionCounter].x = event.target.x
					explosion[explosionCounter].y = event.target.y

				--sceneGroup:insert(explosion[explosionCounter])
				

				explosion[explosionCounter]:setSequence("explosion")
				explosion[explosionCounter]:play()

				local function removeExplosion ()	
						display.remove(explosion[explosionCounter])
				end

				tmr_removeExplosion = timer.performWithDelay(275, removeExplosion)
				explosionCounter=explosionCounter+1
				return true
			end

			--transition.to(rocket, {x=event.target.x, y=event.target.y, time = rocketTime, onComplete = blowUpMeteor})
			blowUpMeteor()



				score=score+1
				scoreText.text = score

				streak = streak + 1
				userStreakText.text = streak

				if(streak > user.streakBest) then
					user.streakBest = streak
					bestStreakText.text = "Best: "..streak
				end

				user.money = user.money + 5
				--moneyText.text = user.money
				if(score > user.best) then
					user.best = score
					userBestText.text = "Best Score: "..score
				end

				loadsave.saveTable(user, "user.json")

				return true
		end
	end
	end
end

  sendMeteors =  function ()
		sendMeteorsCounter = sendMeteorsCounter + 1


		if(sendMeteorsCounter % meteorSendSpeed == 0) then
			--send the meteor
			meteorCounter=meteorCounter+1

			if(pauseButton~=nil) then
				pauseButton:toFront();
			end

			local side = math.random(1, 4)

			meteor[meteorCounter] = display.newImage(sceneGroup, "images/gamescreen/Meteor.png")
			meteor[meteorCounter].x = rightScreen - meteor[meteorCounter].width; meteor[meteorCounter].y = topScreen-meteor[meteorCounter].height
			--move the planet to the front
			parent:insert(meteor[meteorCounter])
			parent:insert(planet)

			--increment the SEND speed of the meteor
			if(meteorSendSpeed > meteorMaxSendSpeed) then
				meteorSendSpeed = meteorSendSpeed - meteorIncrementSendSpeed
			end

			--increment the TRAVEL speed of the meteor
			if (meteorTravelSpeedFactor > meteorMaxTravelSpeedFactor) then
				meteorTravelSpeedFactor = meteorTravelSpeedFactor - meteorIncrementTravelSpeedFactor
			end

			--print(meteorSendSpeed)
			--print(meteorTravelSpeedFactor)

			if(side == 1) then --top
				
					meteor[meteorCounter].x = math.random(leftScreen, rightScreen-70)
					meteor[meteorCounter].y  = topScreen
					targetX = centerX
					targetY = centerY - (planet.height/2) - (meteor[meteorCounter].height)/3
				elseif(side==2) then --right

					meteor[meteorCounter].x = rightScreen
					meteor[meteorCounter].y = math.random(topScreen+70, bottomScreen)
					
					targetX = centerX + (planet.width/2) + (meteor[meteorCounter].width)/3
					targetY = centerY
				elseif(side == 3) then -- bottom
					meteor[meteorCounter].x = math.random(leftScreen, rightScreen)
					meteor[meteorCounter].y = bottomScreen
					targetX = centerX
					targetY = centerY + (planet.height/2) + (meteor[meteorCounter].height)/3
				else                  --left
					meteor[meteorCounter].x = leftScreen
					meteor[meteorCounter].y = math.random(topScreen, bottomScreen)

					targetX = centerX - (planet.width/2) - (meteor[meteorCounter].width)/3
					targetY = centerY

				end

				meteor[meteorCounter].id = meteorCounter

			meteorTravelSpeed = distanceBetween(meteor[meteorCounter], planet)*meteorTravelSpeedFactor--*math.random(0.8, 0.9)
			

			meteor[meteorCounter]:addEventListener("touch", meteorTouched)
				meteor[meteorCounter].trans = transition.to(meteor[meteorCounter], {x = targetX, y = targetY, time = meteorTravelSpeed, rotation = (math.random(1000, 2000)/math.random(3000, 4000))*meteorTravelSpeed, onComplete = planetHit})

		end
	end


	function incrementShootTimer()
		shootTimer = shootTimer+1

		if(score > 100 and score < 120) then
				meteorMaxSendSpeed = 18
			elseif(score >=120 and score<150) then
				meteorMaxSendSpeed = 16
			elseif(score>=150 and score<200) then
				meteorMaxSendSpeed = 14
			elseif(score>=200) then
				meteorMaxSendSpeed = 13
		end
	end


sendMeteorsListener = Runtime:addEventListener("enterFrame", sendMeteors)

 --setting up the shoot timer
 incrementShootTimerListener = Runtime:addEventListener("enterFrame", incrementShootTimer)

local function returnToMenu()
	timer.performWithDelay(sceneSwitchButtonWaitTime, function() composer.gotoScene("scene_menu", {effect = "slideRight"}) end)
end

local function playAgain()
	timer.performWithDelay(sceneSwitchButtonWaitTime, function() composer.gotoScene("scene_gameB", {effect = "slideLeft"}) end)
end

   onGameOver = function()
    	--remove timers
    	if(tmr_removeExplosion) then timer.cancel(tmr_removeExplosion) end
    	--remove global event listeners
    	Runtime:removeEventListener("enterFrame", sendMeteors)
   		Runtime:removeEventListener("enterFrame", incrementShootTimer)

    	transition.cancel()
    	for i = 1, #meteor do
    		if(meteor[i]~=nil) then
    			display.remove(meteor[i])
    		end
    	end

    	if(plusOne[plusOneCounter]~=nil) then
				display.remove(plusOne[plusOneCounter])
		end

    	gameoverBackground = display.newRect(sceneGroup, 0, 0, contentWidth*1.25, contentHeight*1.25)
            gameoverBackground.x = centerX; gameoverBackground.y = centerY
            gameoverBackground:setFillColor(0)
            gameoverBackground.alpha = 0.9


        btn_goToMenu = widget.newButton{
           width = 674,
            height = 394,
            defaultFile = "images/gamescreen/btn_goToMenu.png",
            overFile = "images/gamescreen/btn_goToMenuOver.png",
            onEvent = returnToMenu
   		}
   		btn_goToMenu.alpha = 0
  	 	btn_goToMenu:scale(0.01, 0.01)

   		btn_goToMenu.x = centerX - btn_goToMenu.width/5
   		btn_goToMenu.y = centerY + btn_goToMenu.height/4
   		sceneGroup:insert(btn_goToMenu)


   		btn_playAgain = widget.newButton{
   		width = 922,
   		height = 394,
   		defaultFile = "images/gamescreen/btn_playAgain.png",
   		overFile = "images/gamescreen/btn_playAgainOver.png",
   		onEvent = playAgain
  	 	}
  	 	btn_playAgain.alpha = 0
  	 	btn_playAgain:scale(0.01, 0.01)

  	 	btn_playAgain.x = centerX + btn_playAgain.width/10
  	 	btn_playAgain.y = centerY + btn_playAgain.height/4
  	 	sceneGroup:insert(btn_playAgain)

  	 	timer.performWithDelay(500, function()
  	 		  	 transition.to( btn_playAgain, {alpha = 1, xScale = 0.25, yScale = 0.25, time = 500, transition = easing.outCubic})
  	 		  	 transition.to(btn_goToMenu, {alpha = 1, xScale = 0.25, yScale = 0.25, time = 500, transition = easing.outCubic})
  	 	end)

  	 	meteorsDestroyedTextTop = display.newText(sceneGroup, "You destroyed", 0, 0, font, 20)
		meteorsDestroyedTextTop.x = centerX - meteorsDestroyedTextTop.width/1.3
		meteorsDestroyedTextTop.y = topScreen +meteorsDestroyedTextTop.height/3

		meteorsDestroyedText = display.newText(sceneGroup, score, 0, 0, font, 100)
		meteorsDestroyedText.x = centerX - meteorsDestroyedTextTop.width/1.3
		meteorsDestroyedText.y = topScreen + meteorsDestroyedText.height/3.5

		meteorsDestroyedTextBottom = display.newText(sceneGroup, "Meteors", 0, 0, font, 20)
		meteorsDestroyedTextBottom.x = centerX - meteorsDestroyedTextBottom.width*1.4
		meteorsDestroyedTextBottom.y = topScreen +meteorsDestroyedTextBottom.height*2.5

		gameOverBestScoreText = display.newText(sceneGroup, "Your Best: "..user.best, meteorsDestroyedTextBottom.x, meteorsDestroyedTextBottom.y+40, font, 25)
	 	
 end
 	

   planetHit = function (obj)

    	display.remove(obj)

		audio.play(earthHit)


		if(bestStreak <streak) then
			bestStreak = streak
		end

		if(bestStreak >user.streakBest) then
			user.streakBest = bestStreak
		end
		print(user.streakBest)
		streak = 0
		userStreakText.text = streak


		miniEarth.alpha = 0.5
		miniEarth.xScale = 0.55
		miniEarth.yScale = 0.55
		miniEarth.trans = transition.to(miniEarth, {alpha = 1, xScale = 0.45, yScale = 0.45, time = 500})

	if (healthBar~=nil) then
		if(health >= 7) then
				healthBar:setFillColor(0, 1, 0)
			elseif(health<7 and health>3) then
			 --	healthBar:setFillColor(0.86, 0.75, 0)
			elseif(health<=3) then
				healthBar:setFillColor(1, 0, 0)
		end
	end	

		if(health >= 1) then
			health = health-1
			if(healthBar.xScale~=nil) then
				healthBar.xScale = healthBar.xScale - 1/startingHealth
				-- healthBar:scale(healthBar.xScale - 1/startingHealth, healthBar.yScale)
			end
		else 

			transition.cancel(miniEarth.trans)
			miniEarth.alpha = 1
			miniEarth.xScale = 0.45
			miniEarth.yScale = 0.45
			healthBar.xScale = 0.001
			onGameOver()

		end

	end

	local function pauseToMenu()
		loadsave.saveTable(user, "user.json")
		timer.performWithDelay(sceneSwitchButtonWaitTime, function() composer.gotoScene("scene_menu") end, {effect = "slideLeft"})
	end
	local function restartGame()
		loadsave.saveTable(user, "user.json")
		playAgain()
	end

	local function onPauseTouch(event)
		if(event.phase == "began") then
			if(pauseGame == false) then
				--remove timers
				pauseGame = true

		    --	if(tmr_removeExplosion) then timer.cancel(tmr_removeExplosion) end
		    	--remove global event listeners
		    	Runtime:removeEventListener("enterFrame", sendMeteors)
		   		Runtime:removeEventListener("enterFrame", incrementShootTimer)

		   		local function onPauseMenuSoundTouch(event)
			        if(event.phase == "began") then
			            if(user.playsound == true) then
			                --sound is on and we need to turn it off
			                audio.setVolume(0)
			                pauseMenuSoundToggle.alpha = 0.3
			                user.playsound = false
			            else
			                audio.setVolume(1)
			                pauseMenuSoundToggle.alpha = 1
			                user.playsound = true

			            end
			         end
			         loadsave.saveTable(user, "user.json")
			      end

			      loadsave.saveTable(user, "user.json")

			    pauseMenuSoundToggle = widget.newButton{
		   		width = 50,
		   		height = 50,
		   		defaultFile = "images/gamescreen/soundToggleButton.png",
		   		onEvent = onPauseMenuSoundTouch}

		   		pauseMenuSoundToggle.x = rightScreen-50/1.5
   				pauseMenuSoundToggle.y = topScreen+pauseMenuSoundToggle.height/1.5


			      if(user.playsound == false) then
				        pauseMenuSoundToggle.alpha = 0.3
				        audio.setVolume(0)
				    else
				        audio.setVolume(1)
				        pauseMenuSoundToggle.alpha = 1
				   end

            
    			-- for i = 1, meteorCounter do
    			-- 	if(meteor[meteorCounter]~=nil) then
    			-- 		print(meteorCounter)
    			-- 		meteor[meteorCounter]:removeEventListener("touch", meteorTouched)
    			-- 	end
    			-- end


		    	transition.pause()

		    	pauseBackground = display.newRect(sceneGroup, centerX, centerY, contentWidth*1.5, contentHeight*1.5)
		    	pauseBackground:setFillColor(0, 0, 0)

		    	pauseBackgroundOverlay = display.newRect(sceneGroup, centerX, centerY, contentWidth*1.5, contentHeight*1.5)
		    	pauseBackgroundOverlay:setFillColor(0, 0, 0, 0.7)
		    	pauseBackgroundOverlay:addEventListener("touch", onPauseTouch)

		    	btn_pauseToMenu = widget.newButton{
		    	width = 922,
		    	height = 394,
		    	defaultFile = "images/gamescreen/btn_pauseToMenu.png",
		    	overFile = "images/gamescreen/btn_pauseToMenuOver.png",
		    	onEvent = pauseToMenu
		   		}

		   		btn_pauseToMenu.x = centerX -btn_pauseToMenu.width/12
		   		btn_pauseToMenu.y = centerY + (btn_pauseToMenu.height*1.4)*0.2
		   		btn_pauseToMenu:scale(0.2, 0.2)
		   		sceneGroup:insert(btn_pauseToMenu)

		   		btn_pauseRestart = widget.newButton{
		   			width = 184,
		   			height= 95,
		   			defaultFile = "images/gamescreen/btn_pauseRestart.png",
		   			overFile = "images/gamescreen/btn_pauseRestartOver.png",
		   			onEvent = restartGame
		   		}
		   		btn_pauseRestart.x = centerX + btn_pauseRestart.width/1.4
		   		btn_pauseRestart.y = centerY + btn_pauseRestart.height*1.2
		   		sceneGroup:insert(btn_pauseRestart)



					if(plusOne[plusOneCounter]~=nil) then
					    display.remove(plusOne[plusOneCounter])
					end

		    	parent:insert(pauseBackground)
		    	parent:insert(planet)
		    	parent:insert(earthHole)
		    	parent:insert(healthBar)
		    	parent:insert(miniEarth)
		    	parent:insert(scoreText)
		    	-- parent:insert(moneyText)
		    	-- parent:insert(shootTimerImage)
		    	-- parent:insert(shootTimerImageMarker)

		    	parent:insert(pauseBackgroundOverlay)
		    	parent:insert(pauseButton)
		    	parent:insert(btn_pauseToMenu)
		    	parent:insert(pauseMenuSoundToggle)
		    	parent:insert(btn_pauseRestart)

		    	sceneGroup:insert(btn_pauseToMenu)

		    	display.remove(pauseButton)
		    

		    	pauseText = display.newText(sceneGroup, "Game is Paused", centerX, centerY-80, font, 38)
		    		pauseBestScore = display.newText(sceneGroup, "Your Best Score: "..user.best, centerX, pauseText.y+50, font, 25)


		    	pauseTextInfo = display.newText(sceneGroup, "Tap Anywhere to keep playing", centerX, centerY+50, font, 20)

		    else

		    	pauseGame = false

		    	-- for i = 1, meteorCounter do
    			-- 	if(meteor[meteorCounter]~=nil) then
    			-- 		print(meteorCounter)
    			-- 		meteor[meteorCounter]:addEventListener("touch", meteorTouched)
    			-- 	end
    			-- end

		    	Runtime:addEventListener("enterFrame", sendMeteors)
		   		Runtime:addEventListener("enterFrame", incrementShootTimer)

		   		display.remove(pauseBackground)
		   		display.remove(pauseBackgroundOverlay)

		   		display.remove(pauseText)
		   		display.remove(pauseTextInfo)
		   		display.remove(btn_pauseToMenu)
		   		display.remove(pauseMenuSoundToggle)
		   		display.remove(btn_pauseRestart)
		   		display.remove(pauseBestScore)

		   		transition.resume()


		   		-- pauseBackground.parent:remove(pauseBackground)
		   		-- planet.parent:remove(planet)
		   		-- earthHole.parent:remove(earthHole)
		   		-- healthBar.parent:remove(healthBar)
		   		-- miniEarth.parent:remove(miniEarth)
		   		-- scoreText.parent:remove(scoreText)
		   		-- moneyText.parent:remove(moneyText)
		   		-- pauseBackgroundOverlay.parent:remove(pauseBackgroundOverlay)
		   		-- pauseButton.parent:remove(pauseButton)

				pauseButton = display.newImage(sceneGroup,"images/gamescreen/pauseButton.png")
				pauseButton.x = rightScreen - 25; pauseButton.y = topScreen + 30;
				pauseButton:scale(0.05, 0.05)
				pauseButton:addEventListener("touch", onPauseTouch)


		   	end
	    end

	end


	sendMeteorsCounter = 0
	

	background = display.newImageRect(sceneGroup, "images/gamescreen/blackBackground.png", 2000, 2000)
	background.x = centerX; background.y = centerY;

	planet = display.newImageRect(sceneGroup, "images/gamescreen/Earth.png", 100, 100)

	planet.x = centerX; planet.y = centerY;

	parent = planet.parent

	scoreText = display.newText(sceneGroup, score, 0, 0, font, 48)
	scoreText.x = centerX
	scoreText.y = topScreen + scoreText.height/4

	-- moneyText = display.newText(sceneGroup, user.money, 0, 0, font, 32)
	-- moneyText.x = leftScreen + moneyText.width/2 + 10
	-- moneyText.y = bottomScreen - moneyText.height/3
	-- moneyText.anchorX = 0

	-- coinIcon = display.newImage(sceneGroup, "images/gamescreen/coin.png")
	-- coinIcon:scale(0.5, 0.5)
	-- coinIcon.x = moneyText.x - coinIcon.width*coinIcon.xScale/2-10
	-- coinIcon.y = moneyText.y

	-- moneyTextBackground = display.newRoundedRect(sceneGroup, leftScreen+10, moneyText.y, coinIcon.width*coinIcon.xScale+moneyText.width+30, coinIcon.height*coinIcon.yScale*1.3, 10 )
	-- moneyTextBackground:setFillColor(0.2)
	-- moneyTextBackground.anchorX = 0
	-- moneyTextBackground:toFront()
	-- coinIcon:toFront()
	-- moneyText:toFront()

	healthBar = display.newRect(sceneGroup, 0, 0, 44, 16)
	healthBar.anchorX = 0
	healthBar.x  = rightScreen - 119
	healthBar.y = topScreen+35

	healthBar:setFillColor(0, 1, 0)

	healthBar.xScale = 1.15
	healthBar.yScale = 1.1

	earthHole = display.newImageRect(sceneGroup, "images/gamescreen/EarthHole.png", 104, 52)
	earthHole.x = rightScreen-119; earthHole.y = topScreen+earthHole.height/1.5;

	miniEarth = display.newImageRect(sceneGroup, "images/gamescreen/miniEarth.png", 100, 100)
	miniEarth.x = rightScreen-145; miniEarth.y = topScreen +35;
	miniEarth:scale(0.45, 0.45)

	-- shootTimerImage = display.newImage(sceneGroup, "images/gamescreen/shootTimerImage.png")
	-- shootTimerImage:scale(0.27, 0.23)
	-- shootTimerImage.x = rightScreen - shootTimerImage.width*0.2; shootTimerImage.y = topScreen + shootTimerImage.height*0.28;

	-- shootTimerImageMarker = display.newRect(sceneGroup, 0, 0, 22, 113)
	-- shootTimerImageMarker.x = shootTimerImage.x ; shootTimerImageMarker.y = shootTimerImage.y + 58;
	-- shootTimerImageMarker:setFillColor(1, 1, 1, 0.5)
	-- shootTimerImageMarker.anchorY = 1


	pauseButton = display.newImage(sceneGroup,"images/gamescreen/pauseButton.png")
	pauseButton.x = rightScreen - 25; pauseButton.y = topScreen + 30
	pauseButton:scale(0.05, 0.05)
	pauseButton:addEventListener("touch", onPauseTouch)

	userBestText = display.newText(sceneGroup, "Best Score: "..user.best, 0, 0, font, 25)
	userBestText.x = scoreText.x; userBestText.y = scoreText.y + userBestText.height/1.5


	userStreakText = display.newText(sceneGroup, streak, 0, 0, font, 30)
	userStreakText.anchorX = 0
	userStreakText.x = leftScreen + userStreakText.width*3
	userStreakText.y = topScreen+userStreakText.height/2
	-- userStreakText:setFillColor(0)

	streakIcon = display.newImage(sceneGroup, "images/gamescreen/flame.png")
	streakIcon:scale(0.65, 0.65)
	streakIcon.x = userStreakText.x-userStreakText.width/2-streakIcon.width*streakIcon.xScale/2 +10
	streakIcon.y = userStreakText.y-5

	streakBackground = display.newRoundedRect(sceneGroup, userStreakText.x, userStreakText.y, 90, streakIcon.yScale*streakIcon.height, 10)
	streakBackground:setFillColor(0.2)
	streakBackground.anchorX = 0.5

	bestStreakText = display.newText(sceneGroup, "Best: "..user.streakBest,  0, 0, font, 22)
	bestStreakText.x = streakBackground.x; bestStreakText.y = streakBackground.y + bestStreakText.height;



	parent:insert(streakIcon)
	parent:insert(userStreakText)
	parent:insert(bestStreakText)



end
 
-- for k,v in pairs( _G ) do
--     print( k .. " : ", v )
-- end

-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
         local prevScene = composer.getSceneName("previous")
        if(prevScene) then
            composer.removeScene(prevScene)
        end
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        loadsave.saveTable(user, "user.json")
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
		if(plusOne[plusOneCounter]~=nil) then
		    display.remove(plusOne[plusOneCounter])
		end
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
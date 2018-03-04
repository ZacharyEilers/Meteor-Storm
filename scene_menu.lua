
--I love to eat Pie

--this is the menu scene file

local composer = require( "composer" )
 
local scene = composer.newScene()

local widget = require "widget"

user = loadsave.loadTable("user.json")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local background
 local btn_play
 local btn_soundToggle
 local titleText
 local upperTitleText
 local titleMeteor
 local settingsRect
 local settingsIcon


 -- local welcomeText, welcomeTextLower, enterUsernameTextLimitWarning


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 local composer = require "composer"
-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --functions

    local function playGame()
            timer.performWithDelay(sceneSwitchButtonWaitTime, function() composer.gotoScene("scene_gameA", {effect = "slideLeft"}) end)
            return true
    end


    background = display.newRect(sceneGroup, centerX, centerY, contentWidth*1.5, contentHeight*1.8)
    background:setFillColor(0, 0, 0)

   btn_play = widget.newButton{
     width = 910,
     height = 622,
     defaultFile = "images/menuscreen/btn_play.png",
     overFile = "images/menuscreen/btn_playOver.png",
     onEvent = playGame
    }

    btn_play.x = centerX; btn_play.y = bottomScreen + btn_play.height
    btn_play.alpha = 0
    btn_play:scale(0.21, 0.21)
    sceneGroup:insert(btn_play)


   

    titleText = display.newText(sceneGroup, "Mete    r Storm", 0, 0, font, 50)
    titleText.x = leftScreen - titleText.width; titleText.y = topScreen + titleText.height/1.5

    upperTitleText = display.newText(sceneGroup, "Operation", 0, 0, font, 30)
    upperTitleText.x = rightScreen + upperTitleText.width; upperTitleText.y = topScreen + upperTitleText.height/2;



    titleMeteor = display.newImage("images/menuscreen/titleMeteor.png")
    titleMeteor:scale(0.22, 0.22)
    titleMeteor.x = leftScreen
    titleMeteor.y = centerY
    sceneGroup:insert(titleMeteor)

    local function onSettingsTouch()
             timer.performWithDelay(sceneSwitchButtonWaitTime, function() composer.gotoScene("scene_settings", {effect = "slideDown"}) end)
    end

    local function onSoundTouch(event)
        if(event.phase == "began") then
            if(user.playsound == true) then
                --sound is on and we need to turn it off
                audio.setVolume(0)
                btn_soundToggle.alpha = 0.3
                user.playsound = false
            else
                audio.setVolume(1)
                btn_soundToggle.alpha = 1
                user.playsound = true

            end
            loadsave.saveTable(user, "user.json")
        end
    end


    local function resizeTextWidthToFitContainer(textObject, width, height)
            while textObject.width>width do 
                  textObject.size = textObject.size-1
            end

            return textObject.size
    end




    btn_soundToggle = widget.newButton{
        width = 50,
        height = 50,
        defaultFile = "images/menuscreen/soundToggleButton.png",
        -- overFile = "images/gamescreen/soundToggleButtonOver.png",
        onEvent = onSoundTouch
    }
    sceneGroup:insert(btn_soundToggle)
    if(user.playsound == false) then
        btn_soundToggle.alpha = 0.3
        audio.setVolume(0)
    else
        audio.setVolume(1)
        btn_soundToggle.alpha = 1
    end

    settingsIcon = display.newImage(sceneGroup, "images/menuscreen/settingsIcon.png")
    settingsIcon.x = leftScreen -settingsIcon.width*2 settingsIcon.y = topScreen + 30;
    settingsIcon:scale(0.5, 0.5)
    settingsIcon:addEventListener("touch", onSettingsTouch)




   -- btn_soundToggle:scale(0.2, 0.2)
    btn_soundToggle.x = rightScreen + btn_soundToggle.width*5
    btn_soundToggle.y = topScreen+btn_soundToggle.height/1.5

    transition.to(upperTitleText, {x = centerX, time = 1000, transition =easing.outCubic})

    transition.to(btn_play, {y = centerY+btn_play.height/15, alpha = 1, time = 1000, transition = easing.outCubic})

    transition.to(titleText, {x = centerX, time = 1000, transition = easing.outCubic})

    transition.to(titleMeteor, {x = centerX - titleMeteor.width/4.5, y = titleText.y, rotation = -1080, time = 1000, transition = easing.outCubic, onComplete = function()
        
        transition.to(titleMeteor, {rotation = 360, time = 10000, iterations = -1})

        end})

    transition.to(btn_soundToggle, {x = rightScreen-50/1.5, time = 1000, transition = easing.outCubic}) 

    transition.to(settingsIcon, {x = leftScreen+30, y = topScreen+30, time = 1000, transition = easing.outCubic})



    
       

      
end
 
 
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
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

 
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
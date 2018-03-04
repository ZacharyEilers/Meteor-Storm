local composer = require( "composer" )
local widget = require "widget"
 
local scene = composer.newScene()

local user = loadsave.loadTable("user.json")
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local background
 local title
 local btn_back
 local btn_credits

 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local function goBack()
        timer.performWithDelay(sceneSwitchButtonWaitTime, function() composer.gotoScene("scene_menu", {effect = "slideUp"}) end)
        return true
    end
    local function gotoCredits()
         timer.performWithDelay(sceneSwitchButtonWaitTime, function() composer.gotoScene("scene_credits", {effect = "slideDown"}) end)
         return true
    end


    local function toggleShowBestText(event)
        if(event.phase == "ended")  then     
           if (user.showUserBestText == true) then
                user.showUserBestText = false
                btn_toggleShowUserBestText.alpha = 0.6
             else
                user.showUserBestText = true
                btn_toggleShowUserBestText.alpha = 1
            end
                loadsave.saveTable(user, "user.json")
            return true
        end
    end

    local function toggleShowStreakBestText(event)
        if(event.phase == "ended")  then     
           if (user.showBestStreakText == true) then
                user.showBestStreakText = false
                btn_toggleShowBestStreakText.alpha = 0.6
             else
                user.showBestStreakText = true
                btn_toggleShowBestStreakText.alpha = 1
            end
                loadsave.saveTable(user, "user.json")
            return true
        end
    end

    background = display.newRect(sceneGroup, centerX, centerY, contentWidth*1.5, contentHeight*1.5)
    background:setFillColor(1)

    title = display.newText(sceneGroup, "Settings", centerX-30, topScreen + 40, font, 40)
    title:setFillColor(0)

    btn_back = widget.newButton {
        width = 672,
        height = 331,
        defaultFile = "images/settingsScreen/btn_back.png",
        overFile = "images/settingsScreen/btn_backOver.png",
        onEvent = goBack
    }
    btn_back.x = centerX; btn_back.y = bottomScreen-40;
    btn_back:scale(0.2, 0.2)
    sceneGroup:insert(btn_back)

    btn_toggleShowUserBestText = widget.newButton {
        width = 1613,
        height = 252,
        defaultFile = "images/settingsScreen/btn_toggleShowBestScore.png",
        overFile = "images/settingsScreen/btn_toggleShowBestScore_Over.png",
        onEvent = toggleShowBestText
    }
    btn_toggleShowUserBestText.x = centerX - btn_toggleShowUserBestText.width*0.1/1.2
    btn_toggleShowUserBestText.y = centerY - 50
    btn_toggleShowUserBestText:scale(0.15, 0.15)
    sceneGroup:insert( btn_toggleShowUserBestText )

    btn_toggleShowBestStreakText = widget.newButton{
        width = 1765,
        height = 252,
        defaultFile = "images/settingsScreen/btn_toggleShowBestStreak.png",
        overFile = "images/settingsScreen/btn_toggleShowBestStreak_Over.png",
        onEvent = toggleShowStreakBestText
    }
    btn_toggleShowBestStreakText.x = centerX + btn_toggleShowBestStreakText.width*0.1/1.2
    btn_toggleShowBestStreakText.y = centerY - 50
    btn_toggleShowBestStreakText:scale(0.15, 0.15)
    sceneGroup:insert( btn_toggleShowBestStreakText )

    if(user.showBestStreakText == true) then
        btn_toggleShowUserBestText.alpha = 1
    else
        btn_toggleShowUserBestText.alpha = 0.6
    end
    print("streak: "..tostring(user.showUserBestText))

    if(user.showUserBestText == true) then
        btn_toggleShowBestStreakText.alpha = 1
    else
        btn_toggleShowBestStreakText.alpha = 0.6
    end
    print("best: "..tostring(user.showBestStreakText))


    btn_credits = widget.newButton {
        width = 398,
        height = 106,
        defaultFile = "images/settingsScreen/btn_credits.png",
        overFile = "images/settingsScreen/btn_creditsOver.png",
        onRelease = gotoCredits
    }
    btn_credits.x =  centerX + contentWidth/2.5; btn_credits.y = topScreen + 40
    btn_credits:scale(0.35, 0.35)
    sceneGroup:insert(btn_credits)


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
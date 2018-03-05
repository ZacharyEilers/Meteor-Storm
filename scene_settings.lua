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



    btn_credits = widget.newButton {
        width = 398,
        height = 106,
        defaultFile = "images/settingsScreen/btn_credits.png",
        overFile = "images/settingsScreen/btn_creditsOver.png",
        onRelease = gotoCredits
    }
    btn_credits.x =  centerX; btn_credits.y = centerY
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
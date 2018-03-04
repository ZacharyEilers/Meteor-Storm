local composer = require( "composer" )
local widget = require "widget"
 
local scene = composer.newScene()
local user = loadsave.loadTable("user.json")

user = loadsave.loadTable("user.json")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local background
 local text
 local btn_gotoMenu
 local tmr_fadeInSkipButton
 local fadeInSkipButtonTrans
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    background = display.newRect(sceneGroup, centerX, centerY, contentWidth*1.5, contentHeight*1.5)
    background:setFillColor(0)

    text  = display.newText(sceneGroup, "A large group of previously undetected meteors are heading towards Earth. It would take only a few of them to wipe out all life on Earth forever.  You have been tasked with destroying these meteors one by one before they reach Earth. Your headquarters, where you will locate and fire missiles to destroy the meteors, is equipped with state-of-the art technology that allows you to view the entire globe and coordinate missile launches anywhere in the world. Good luck!", centerX, centerY, contentWidth/1.1, contentHeight/1.1, altFont, 21)
  --  text.width = contentWidth/1.2; text.height = contentHeight/2;


  local function gotoMenu()
  user.newUser = false
  loadsave.saveTable(user, "user.json")
  timer.performWithDelay(sceneSwitchButtonWaitTime, function() composer.gotoScene("scene_menu", {effect = "fade"}) end)
  end


  btn_gotoMenu = widget.newButton {
  width = 150,
  height = 35,
  defaultFile = "images/introscreen/btn_gotoMenu.png",
  overFile = "images/introscreen/btn_gotoMenuOver.png",
  onEvent = gotoMenu
    }
    btn_gotoMenu.x = centerX + btn_gotoMenu.width/1.5
    btn_gotoMenu.y = bottomScreen - 25
    btn_gotoMenu.alpha = 0
    sceneGroup:insert(btn_gotoMenu)

   tmr_fadeInSkipButton = timer.performWithDelay(5000, function()
       fadeInSkipButtonTrans = transition.to(btn_gotoMenu, {alpha = 1, time = 1000})
    end)




 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
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
local composer = require( "composer" )
local widget = require "widget"
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local background
 local title
 local btn_back
 --local earthIcon
 local earthIconText
 local btn_smashIcons, btn_smashIcons

 local earthIconText, earthIcon

 local fireIcon, fireIconText, btn_fireIconCreator, btn_flaticon2

 local coinIcon, coinIconText, btn_smashIcons2, btn_flaticon3

 local montSerratFontTitle, btn_montserratLicense

local bungeeFontTitle, btn_bungeeLicense

local robotoCondensedFontTitle, btn_robotoCondensedLicense

 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local function goBack()
        timer.performWithDelay(sceneSwitchButtonWaitTime, function() composer.gotoScene("scene_settings", {effect = "slideUp"}) end)
        return true
    end


    local function Smashicons()
        --if(event.phase == "began") then
            system.openURL("https://smashicons.com/")
       -- end
    end

    local function flaticon()
        system.openURL("https://www.flaticon.com/")
    end

    local function fireIconCreator()
        system.openURL("https://www.iconfinder.com/kirill.kazachek")
    end

    local function gotoOFL()
        system.openURL("https://opensource.org/licenses/OFL-1.1")
    end
     

    background = display.newRect(sceneGroup, centerX, centerY, contentWidth*1.5, contentHeight*1.5)
    background:setFillColor(1)

    btn_back = widget.newButton {
        width = 672,
        height = 331,
        defaultFile = "images/settingsScreen/btn_back.png",
        overFile = "images/settingsScreen/btn_backOver.png",
        onEvent = goBack
    }
    btn_back.x = centerX; btn_back.y = bottomScreen-40;
    btn_back:scale(0.15, 0.15)
    sceneGroup:insert(btn_back)

    title = display.newText(sceneGroup, "Credits", centerX, topScreen+30, font, 40)
    title:setFillColor(0)

    local scrollView = widget.newScrollView
    {
        left = 0,
        top = topScreen + title.height/2,
        width = display.actualContentWidth,
        height = display.contentHeight-title.height - btn_back.height*0.15 +20,
        hideBackground = true,
        topPadding = 50,
        bottomPadding = 50,
        horizontalScrollDisabled = true,
        verticalScrollDisabled =  false
    }
    sceneGroup:insert(scrollView)


    --earth icon

    earthIcon = display.newImage(sceneGroup, "images/settingsScreen/creditsScreen/earthIcon.png")
    earthIcon.x =leftScreen + 100; earthIcon.y = topScreen
    earthIcon:scale(0.5, 0.5)
    scrollView:insert(earthIcon)

    earthIconText = display.newText(sceneGroup, "Icon made by Smashicons from flaticon.com", 0, earthIcon.y+50, altFont, 20)
    earthIconText:setFillColor(0)
    earthIconText.x = centerX
    scrollView:insert(earthIconText)

    btn_smashIcons = widget.newButton {
        width = 585,
        height = 106,
        defaultFile = "images/settingsScreen/creditsScreen/smashicon.png",
        overFile = "images/settingsScreen/creditsScreen/smashiconOver.png",
        onRelease = Smashicons
    }
    btn_smashIcons.x = centerX-btn_smashIcons.width*0.25/2; btn_smashIcons.y = earthIcon.y
    btn_smashIcons:scale(0.25, 0.25)
    sceneGroup:insert(btn_smashIcons)
    scrollView:insert(btn_smashIcons)

    btn_flaticon = widget.newButton {
        width = 585,
        height = 106,
        defaultFile = "images/settingsScreen/creditsScreen/flaticon.png",
        overFile = "images/settingsScreen/creditsScreen/flaticonOver.png",
        onRelease = flaticon
    }
    btn_flaticon.x = btn_smashIcons.x + btn_smashIcons.width*0.25/2+btn_flaticon.width*0.25/1.5; btn_flaticon.y = earthIcon.y
    btn_flaticon:scale(0.25, 0.25)
    sceneGroup:insert(btn_flaticon)
    scrollView:insert(btn_flaticon)




    --fire icon

    fireIcon = display.newImage(sceneGroup, "images/gamescreen/flame.png")
    fireIcon.x = earthIcon.x
    fireIcon.y = earthIconText.y + fireIcon.height
    fireIcon:scale(0.75, 0.75)
    scrollView:insert(fireIcon)

    fireIconText = display.newText(sceneGroup, "Icon made by Kirill Kazachek from flaticon.com", 0, fireIcon.y+40, altFont, 20)
    fireIconText:setFillColor(0)
   fireIconText.x = centerX
    scrollView:insert(fireIconText)

    btn_fireIconCreator = widget.newButton {
         width = 585,
        height = 106,
        defaultFile = "images/settingsScreen/creditsScreen/fireIconCreator.png",
        overFile = "images/settingsScreen/creditsScreen/fireIconCreatorOver.png",
        onRelease = fireIconCreator
    }
    btn_fireIconCreator.x = centerX-btn_fireIconCreator.width*0.25/2; btn_fireIconCreator.y = fireIcon.y
    btn_fireIconCreator:scale(0.25, 0.25)
    sceneGroup:insert(btn_fireIconCreator)
    scrollView:insert(btn_fireIconCreator)


     btn_flaticon2 = widget.newButton {
        width = 585,
        height = 106,
        defaultFile = "images/settingsScreen/creditsScreen/flaticon.png",
        overFile = "images/settingsScreen/creditsScreen/flaticonOver.png",
        onRelease = flaticon
    }
    btn_flaticon2.x = btn_smashIcons.x + btn_smashIcons.width*0.25/2+btn_flaticon2.width*0.25/1.5; btn_flaticon2.y = fireIcon.y
    btn_flaticon2:scale(0.25, 0.25)
    sceneGroup:insert(btn_flaticon2)
    scrollView:insert(btn_flaticon2)



    --coin icon

    --  coinIcon = display.newImage(sceneGroup, "images/gamescreen/coin.png")
    -- coinIcon.x = earthIcon.x
    -- coinIcon.y = fireIconText.y + coinIcon.height
    -- coinIcon:scale(0.75, 0.75)
    -- scrollView:insert(coinIcon)

    -- coinIconText = display.newText(sceneGroup, "Icon made by Smashicons from flaticon.com", 0, coinIcon.y+40, altFont, 20)
    -- coinIconText:setFillColor(0)
    -- coinIconText.x = centerX
    -- scrollView:insert(coinIconText)


    --  btn_smashIcons2 = widget.newButton {
    --     width = 585,
    --     height = 106,
    --     defaultFile = "images/settingsScreen/creditsScreen/smashicon.png",
    --     overFile = "images/settingsScreen/creditsScreen/smashiconOver.png",
    --     onRelease = Smashicons
    -- }
    -- btn_smashIcons2.x = centerX-btn_smashIcons2.width*0.25/2; btn_smashIcons2.y = coinIcon.y
    -- btn_smashIcons2:scale(0.25, 0.25)
    -- sceneGroup:insert(btn_smashIcons2)
    -- scrollView:insert(btn_smashIcons2)

    -- btn_flaticon3 = widget.newButton {
    --     width = 585,
    --     height = 106,
    --     defaultFile = "images/settingsScreen/creditsScreen/flaticon.png",
    --     overFile = "images/settingsScreen/creditsScreen/flaticonOver.png",
    --     onRelease = flaticon
    -- }
    -- btn_flaticon3.x = btn_smashIcons.x + btn_smashIcons2.width*0.25/2+btn_flaticon3.width*0.25/1.5; btn_flaticon3.y = coinIcon.y
    -- btn_flaticon3:scale(0.25, 0.25)
    -- sceneGroup:insert(btn_flaticon3)
    -- scrollView:insert(btn_flaticon3)


    --Monteserrat Font Licenses

    -- montSerratFontTitle = display.newText(sceneGroup, "Monteserrat Font", 0, 0, usernameFont, 30)
    -- montSerratFontTitle:setFillColor(0)
    -- montSerratFontTitle.x = centerX
    -- montSerratFontTitle.y = coinIconText.y +50
    -- scrollView:insert(montSerratFontTitle)

    -- btn_montserratLicense = widget.newButton{
    --     width = 820,
    --     height = 170,
    --     defaultFile = "images/settingsScreen/creditsScreen/btn_montserratLicense.png",
    --     overFile = "images/settingsScreen/creditsScreen/btn_montserratLicenseOver.png",
    --     onRelease = gotoOFL
    -- }

    -- btn_montserratLicense:scale(0.25, 0.25)
    -- btn_montserratLicense.x = centerX; btn_montserratLicense.y = montSerratFontTitle.y + btn_montserratLicense.height*btn_montserratLicense.yScale
    -- sceneGroup:insert(btn_montserratLicense)    
    -- scrollView:insert(btn_montserratLicense)

    --Bungee License

    bungeeFontTitle = display.newText(sceneGroup, "Bungee Font", 0, 0, font, 30)
    bungeeFontTitle:setFillColor(0)
    bungeeFontTitle.x = centerX
    bungeeFontTitle.y = fireIconText.y + fireIconText.height*fireIconText.yScale + 40
    scrollView:insert(bungeeFontTitle)

    btn_bungeeLicense = widget.newButton{
        width = 745,
        height = 170,
        defaultFile = "images/settingsScreen/creditsScreen/btn_bungeeLicense.png",
        overFile = "images/settingsScreen/creditsScreen/btn_bungeeLicenseOver.png",
        onRelease = gotoOFL
    }

    btn_bungeeLicense:scale(0.25, 0.25)
    btn_bungeeLicense.x = centerX; btn_bungeeLicense.y = bungeeFontTitle.y + btn_bungeeLicense.height*btn_bungeeLicense.yScale
    sceneGroup:insert(btn_bungeeLicense)    
    scrollView:insert(btn_bungeeLicense)


    -- roboto Condensed

    robotoCondensedFontTitle = display.newText(sceneGroup, "Roboto Condensed Font", 0, 0, altFont, 30)
    robotoCondensedFontTitle:setFillColor(0)
    robotoCondensedFontTitle.x = centerX
    robotoCondensedFontTitle.y = btn_bungeeLicense.y + robotoCondensedFontTitle.height*robotoCondensedFontTitle.yScale + 40
    scrollView:insert(robotoCondensedFontTitle)

    btn_robotoCondensedLicense = widget.newButton {
        width = 767,
        height = 175,
        defaultFile = "images/settingsScreen/creditsScreen/btn_robotoCondensedLicense.png",
        overFile = "images/settingsScreen/creditsScreen/btn_robotoCondensedLicenseOver.png",
        onRelease = gotoOFL
    }

    btn_robotoCondensedLicense:scale(0.25, 0.25)
    btn_robotoCondensedLicense.x = centerX; btn_robotoCondensedLicense.y = robotoCondensedFontTitle.y + btn_robotoCondensedLicense.height*btn_robotoCondensedLicense.yScale;
    sceneGroup:insert(btn_robotoCondensedLicense)    
    scrollView:insert(btn_robotoCondensedLicense)




    -- earthIconLinkSmashicons = display.newText(sceneGroup, "Smashicons", centerX + 12, earthIconText.y, altFont, 25)
    -- earthIconLinkSmashicons:setFillColor(0, 0, 1)
    -- earthIconLinkSmashicons:addEventListener("tap", Smashicons)

    -- earthIconLinkFlatIcon = display.newText(sceneGroup, "flaticon.com", centerX+190, earthIcon.y, altFont, 25)
    -- earthIconLinkFlatIcon:setFillColor(0, 0, 1)
    -- earthIconLinkFlatIcon:addEventListener("tap", flaticon)








 
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
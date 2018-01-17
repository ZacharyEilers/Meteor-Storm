local firebaseDatabase = require "plugin.firebaseDatabase"
firebaseDatabase.init()


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


 local usernameTextBoxInTransition = true

 local creatingUsername = false

 local firstEnter = true
 local creatingUsernameOverlay

-- local startAllowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIKLMNOPQRSTUVWXYZ123456789"

-- local startsWithAllowedChar = false
local usernameFitsLengthRequirement = false
local usernameIsUnique = true

local usernameLengthLimit = 30

   


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
        if(creatingUsername == false) then
            timer.performWithDelay(sceneSwitchButtonWaitTime, function() composer.gotoScene("scene_gameA", {effect = "slideLeft"}) end)
            return true
        end
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
        if(creatingUsername == false) then
             timer.performWithDelay(sceneSwitchButtonWaitTime, function() composer.gotoScene("scene_settings", {effect = "slideDown"}) end)
             return true
         end
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


    local function clearAll()
        display.remove(usernameLengthWarning)

        display.remove(usernameUniqueWarning)
        display.remove(usernameUniqueWarningBackground)

        display.remove(creatingUsernameWindow)
        display.remove(enterUsernameText)
        display.remove(enterUsernameTextBackground)

        display.remove(enterUsernameTextLimitWarning)

        display.remove(usernameUniqueText)

        display.remove(usernameLengthWarningBackground)

        display.remove(btn_submitUsername)
        display.remove(usernameTextBox)

        display.remove(creatingUsernameOverlay)

        creatingUsername = false
    end

    local function submitUsername(e)

        if (btn_submitUsername.alpha == 1) then

        local function listenerForSetUsername(event)
            if(event.isError) then
                native.showAlert( "Could not send Data", event.error, {"Ok"} )
            else
                native.showAlert( "Data sent", user.username, {"Ok"} )
            end

      end
    

        native.setKeyboardFocus(nil)
        user.username = usernameTextBox.text
        firebaseDatabase.set(user.username, user.best, listenerForSetUsername)
        firebaseDatabase.set("Global Leaderboard", {{username = "Zachary", score = 1}, {username = "Wes", score = 2}}, listenerForSetUsername) 
        clearAll()

    end

    end

    

    local function setUpUser()

        local function raiseUsernameTextBox(event)
            if (event.phase == "began" and firstEnter == true) then

                firstEnter = false
                       local function showUsernameRequirements()
                            usernameLengthWarningBackground = display.newRoundedRect(sceneGroup, 0, 0, 300, 48, 10)
                            usernameLengthWarningBackground.x = creatingUsernameWindow.x - creatingUsernameWindow.width/2 + usernameLengthWarningBackground.width/2
                            usernameLengthWarningBackground.y = creatingUsernameWindow.y - creatingUsernameWindow.height/2 +usernameLengthWarningBackground.height/2
                            usernameLengthWarningBackground:setFillColor(0.4)
                            usernameLengthWarningBackground:toFront()

                            usernameLengthWarning = display.newText(sceneGroup, "At least 2 but less than "..usernameLengthLimit.." characters", usernameLengthWarningBackground.x, usernameLengthWarningBackground.y, altFontBold, 50)
                            usernameLengthWarning.size = resizeTextWidthToFitContainer(usernameLengthWarning, usernameLengthWarningBackground.width, usernameLengthWarning.height)


                            usernameUniqueWarningBackground = display.newRoundedRect(sceneGroup, 0, 0, 300, 48, 10)
                            usernameUniqueWarningBackground.x = creatingUsernameWindow.x - creatingUsernameWindow.width/2 + usernameUniqueWarningBackground.width/2
                            usernameUniqueWarningBackground.y = creatingUsernameWindow.y + creatingUsernameWindow.height/2 - usernameLengthWarningBackground.height/2
                            usernameUniqueWarningBackground:setFillColor(0.4)
                            usernameUniqueWarningBackground:toFront()

                            usernameUniqueWarning = display.newText(sceneGroup, "Is Unique", usernameUniqueWarningBackground.x, usernameUniqueWarningBackground.y, altFontBold, 30)
                            usernameUniqueWarning.size = resizeTextWidthToFitContainer(usernameUniqueWarning, usernameUniqueWarningBackground.width, usernameUniqueWarningBackground.height)


                            -- usernameStartCharWarningBackground = display.newRoundedRect(sceneGroup, 0, 0, 300, 30, 10)
                            -- usernameStartCharWarningBackground.x = creatingUsernameWindow.x - creatingUsernameWindow.width/2 + usernameStartCharWarningBackground.width/2
                            -- usernameStartCharWarningBackground.y = creatingUsernameWindow.y + creatingUsernameWindow.height/2 - usernameStartCharWarningBackground.height/2
                            -- usernameStartCharWarningBackground:setFillColor(0.4)
                            -- usernameStartCharWarningBackground:toFront()

                            -- usernameStartCharWarning = display.newText(sceneGroup, "Starts with alphanumeric character", usernameStartCharWarningBackground.x, usernameStartCharWarningBackground.y, altFontBold, 25)
                            -- usernameStartCharWarning.size = resizeTextWidthToFitContainer(usernameStartCharWarning, usernameStartCharWarningBackground.width, usernameStartCharWarningBackground)


                            btn_submitUsername = widget.newButton{
                                width = 728,
                                height = 233,
                                defaultFile = "images/menuscreen/btn_submitUsername.png",
                                overFile = "images/menuscreen/btn_submitUsernameOver.png",
                                onRelease = submitUsername
                            }

                            btn_submitUsername:scale(0.17, 0.17)
                            btn_submitUsername.x = usernameLengthWarning.x + usernameLengthWarning.width/2 + btn_submitUsername.width/2*btn_submitUsername.xScale + 5
                            btn_submitUsername.y = creatingUsernameWindow.y - creatingUsernameWindow.height/2 +btn_submitUsername.height/2*btn_submitUsername.yScale + 5 
                            btn_submitUsername.alpha = 0.3
                       end

                      
                   transition.to(usernameTextBox, { y =  topScreen + usernameTextBox.height + 30, time = 1000, transition = easing.inOutCubic, onComplete = function()
                       usernameTextBoxInTransition = false
                   end})

                   transition.to(enterUsernameText, {y = topScreen+30, time = 1000, transition = easing.inOutCubic})
                   enterUsernameText:setFillColor(1)

                   enterUsernameTextBackground = display.newRoundedRect(sceneGroup, 0, topScreen + 30, creatingUsernameWindow.width, enterUsernameText.height+50, 10)
                   enterUsernameTextBackground.x = leftScreen - enterUsernameTextBackground.width
                    
                    transition.to(enterUsernameTextBackground, {x = centerX, time = 1000, transition = easing.inOutCubic, onComplete = showUsernameRequirements})
                    enterUsernameTextBackground:setFillColor(0.4)

                    enterUsernameText:toFront()

                    transition.to(creatingUsernameWindow, {y = topScreen + usernameTextBox.height + 30 + 80, height = 100, time = 1000, transition = easing.inOutCubic})

                   display.remove(welcomeText)
                   display.remove(welcomeTextLower)
                   display.remove(usernameUniqueText)
                   display.remove(enterUsernameTextLimitWarning)


                elseif (event.phase == "editing") then


                    print(usernameTextBoxInTransition)
                if(usernameTextBoxInTransition == false) then

                    --check length
                    if(usernameTextBox.text:len()>1 and usernameTextBox.text:len()<usernameLengthLimit) then
                        usernameFitsLengthRequirement = true
                        usernameLengthWarningBackground:setFillColor(0, 0.6, 0)
                    else
                        usernameFitsLengthRequirement = false
                        usernameLengthWarningBackground:setFillColor(0.6, 0, 0)
                    end



                    --check starting character
                    -- for i=1, startAllowedChars:len() do
                    --     if(usernameTextBox.text:sub(1, 1) == startAllowedChars:sub(i, i)) then
                    --         startsWithAllowedChar = true
                    --         usernameStartCharWarningBackground:setFillColor(0, 0.6, 0)
                    --         break
                    --     elseif (usernameTextBox.text == "") then
                    --         startsWithAllowedChar = false
                    --         usernameStartCharWarningBackground:setFillColor(0.4)
                    --     else
                    --         startsWithAllowedChar = false
                    --         usernameStartCharWarningBackground:setFillColor(0.6, 0, 0)
                    --     end
                    -- end

                    if(usernameFitsLengthRequirement == true and usernameIsUnique == true) then
                        btn_submitUsername.alpha = 1
                    else
                        btn_submitUsername.alpha = 0.7
                    end
                end

                elseif (event.phase == "submitted") then

                native.setKeyboardFocus(nil)

            end

        end

        local function showTextBox()

            usernameUniqueText = display.newText(sceneGroup, "Your username is unique to you; \nno one else can have the same username", centerX, centerY+10, altFontBold, 18)
                usernameUniqueText:setFillColor(0.2)

            usernameTextBox = native.newTextField(centerX, centerY + usernameUniqueText.height + 20, creatingUsernameWindow.width/1.2, 40)
            usernameTextBox:setReturnKey("done")
            usernameTextBox.placeholder = "Username"
            usernameTextBox.size = 20
            usernameTextBox:addEventListener("userInput", raiseUsernameTextBox)
            usernameTextBox.autocorrectionType = "UITextAutocorrectionTypeNo"
            usernameTextBox.spellCheckingType = "UITextSpellCheckingTypeNo"
            usernameTextBox.font = native.newFont(usernameFont, 20)
            usernameTextBox:resizeHeightToFitFont()
            sceneGroup:insert(usernameTextBox)


            enterUsernameTextLimitWarning = display.newText(sceneGroup, "Your username cannot be longer than "..usernameLengthLimit.." characters and must be at least 2 characters", centerX, 0, creatingUsernameWindow.width - 20, 0, altFontBold, 20)
            enterUsernameTextLimitWarning.y = usernameTextBox.y + enterUsernameTextLimitWarning.height*1.2
            enterUsernameTextLimitWarning:setFillColor(0.6, 0, 0)
            sceneGroup:insert(enterUsernameTextLimitWarning)
        end

        local function showWelcomeText()
            --add some text to welcome and guide the new user
            welcomeText = display.newText(sceneGroup, "Hi", centerX, 0, font, 48)
            welcomeText.y = topScreen + welcomeText.height/4
            welcomeText.alpha = 0
            sceneGroup:insert(welcomeText)

            welcomeTextLower = display.newText(sceneGroup, "Let's get you set up with Operation Meteor Storm", centerX, 0, font, 20)

            --auto-format the text to the appropriate screen size
            welcomeTextLower.size = resizeTextWidthToFitContainer(welcomeTextLower, contentWidth, contentHeight)

            welcomeTextLower.y = welcomeText.y + welcomeTextLower.height 
            welcomeTextLower.alpha = 0
            sceneGroup:insert(welcomeTextLower)

            enterUsernameText = display.newText(sceneGroup, "Please enter your username", centerX, 0, altFontBold, 25)
            enterUsernameText.y = creatingUsernameWindow.y -creatingUsernameWindow.height/2+ enterUsernameText.height/1.5
            enterUsernameText:setFillColor(0.2)
            enterUsernameText.alpha = 0
            sceneGroup:insert(enterUsernameText)

            transition.to(welcomeText, {alpha = 1, time = 1000, onComplete = function()
                transition.to(welcomeTextLower, {alpha = 1, time = 1000, onComplete = function ()
                transition.to(enterUsernameText, {alpha = 1, time = 750, onComplete = showTextBox})
                end})
            end}) 

        end
        -- darken the rest of the menuscreen to focus on the text box
          creatingUsernameOverlay = display.newRect(sceneGroup, centerX, centerY, contentWidth*1.5, contentHeight*1.5)
        creatingUsernameOverlay:setFillColor(0)
        creatingUsernameOverlay.alpha = 0.9
        sceneGroup:insert(creatingUsernameOverlay)


        --create a window for the text box to reside in
        creatingUsernameWindow = display.newRoundedRect(sceneGroup, leftScreen, centerY, contentWidth/1.1, contentHeight/1.5, 10)
        creatingUsernameWindow.x = leftScreen - creatingUsernameWindow.width
        creatingUsernameWindow.y = centerY + creatingUsernameWindow.height/5
        creatingUsernameWindow.alpha = 0
        creatingUsernameWindow:setFillColor(0.8)
        sceneGroup:insert(creatingUsernameWindow)

        --showTextBox()

        transition.to(creatingUsernameWindow, {alpha = 1, x = centerX, time = 1200, transition = easing.inOutExpo, onComplete = showWelcomeText})
    

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


    if(newUser == true) then
        creatingUsername = true
        timer.performWithDelay(500, setUpUser)
    end

    
       

      
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
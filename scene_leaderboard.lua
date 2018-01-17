local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local widget =  require("widget")


 
 --retrieve data and put it into a tables, one for names, and one for scores, 
 --with their indices corresponing

 --order the scores, and order the corresponding names appropiately


 --TO DO: 
   --add a special color to the 1st, 2nd, 3rd, top 10, top 100 players
   --add an fire icon next to the streak
   --clip the names at a certain number of characters. if the name is longer than x amount of characters, than only display the characters that will fit.
   --create a naming system in the app, a name is required when the player first reaches the menu screen, and can be changed once in settings
   --store the key to the player's global highscore locally, and store the player's name locally
   --add a button in settings to change the color theme of the leaderboard scene between black background and white cards to a white background with black cards
   --make it to where the top 100  are shown, along with the 50 people ranked alongside the player
   --create a text box to input a rank in and the leaderboard will scroll to that rank and load the players around it
   --allow the player to choose how many people's rankings to load, in settings
   --ADD STREAK TO THE GAME SCENE
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
     math.randomseed( os.time() )
    
    local names = {"John", "Sally", "Tim", "Zachary", "Grace", "Kylee", "Wes", "Evan", "Susanna", "Bradley"}


    local returnFromFirebase = {}

    namesMaxIndex = table.maxn(names)
    --populate the return from firebase table
    for i = 1, 100 do
        returnFromFirebase[i] = {username = names[math.random(1, namesMaxIndex)], highscore = math.random(0, 100), streak = math.random(1, 2), isTied = false}
    end


    local function compare( a, b )
        if(a.highscore ~= b.highscore) then
            return a.highscore > b.highscore  -- Note ">" as the operator
        elseif(a.streak ~= b.streak) then
            return a.streak > b.streak
        else
           -- a.isTied = true
            b.isTied = true
            return a.highscore > b.highscore
        end
    end
 
table.sort( returnFromFirebase, compare )
    

    -- local maxNumber
    -- local currentMax = 0
    -- for i = 1, names.maxn() do
    --     if (currentMax < names[i]) then

    --     end
    -- end

    -- local sortedScores = {}

    -- for i = 1, names.maxn() do
    --     for i = 1, names.maxn() do
    --         if()
    --     end
    -- end




    local function scrollListener(event)
        local phase = event.phase
        local direction = event.direction

        if(event.limitReached) then
            if("up" == direction) then
                print("Reached top limit")
            elseif("down" == direction) then
                print("reached bottom limit")
            end
        end

        return true
    end

    --create a scrollview
    local scrollView = widget.newScrollView
    {
        left = 0,
        top = 0,
        width = display.contentWidth,
        height = display.contentHeight,
        hideBackground = true,
        topPadding = 50,
        bottomPadding = 50,
        horizontalScrollDisabled = true,
        verticalScrollDisabled =  false,
        listener = scrollListener--,
    }

    local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth*1.5, display.contentHeight*1.5)
    bg:setFillColor(0)
    sceneGroup:insert(bg)

    local text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque commodo, dui eget finibus iaculis, dui neque mollis nisi, sit amet dignissim lectus neque at justo. Nunc imperdiet placerat purus, auctor lobortis erat ullamcorper sit amet. Sed ex purus, feugiat molestie erat vel, congue elementum arcu. Fusce sapien dolor, pulvinar sit amet tortor at, ornare euismod turpis. Pellentesque id tortor augue. Morbi ac nisl nec magna consequat pharetra. Fusce ut hendrerit nisl. Morbi quis magna blandit, interdum felis ac, rhoncus metus. Maecenas ut aliquam odio, sit amet consequat felis. Donec semper faucibus lorem. Proin ut mauris eget orci posuere gravida sed vitae tellus. Nullam ut sodales erat, sed tincidunt augue. Maecenas consequat pellentesque leo, in mollis metus fringilla a. In at ultrices eros, vel gravida ipsum."
   -- local group = display.newGroup()
    local cards = {}

    for i = 0, 99 do
        local rect = display.newRoundedRect(sceneGroup, centerX, i*100+20, display.contentWidth, 80, 10)
        rect:setFillColor(1)
        cards[i] = rect
       -- group:insert(rect)
        scrollView:insert(rect)
    end



        local rankText = {}
        local nameText = {}
        local highScoreText = {}
        local streakText = {}

        local rankCounter = 0

        local nextIsTied = false
    for i = 0, 99 do
        rankCounter = rankCounter + 1

        --display the rankings
        local rank = display.newText(sceneGroup, rankCounter, centerX-display.contentWidth/2 + 30, i*100+20, usernameFont, 35)
        rank:setFillColor(0)
        rankText[i] = rank
        scrollView:insert(rank)

        --display the names
        local name = display.newText(sceneGroup, returnFromFirebase[i+1].username, rank.x + 50, i*100+20, usernameFont, 30)
        name:setFillColor(0)
        name.anchorX = 0
        nameText[i] = name
        scrollView:insert(name)

        --display the scores
        local score = display.newText(sceneGroup, returnFromFirebase[i+1].highscore, centerX+display.contentWidth/2-60, i*100+20, usernameFont, 45)
        score:setFillColor(0)
        highScoreText[i] = score
        scrollView:insert(score)

        local streak = display.newText(sceneGroup, returnFromFirebase[i+1].streak, centerX + 100, i*100+20, usernameFont, 30)
        streak:setFillColor(0.98, 0.37, 0)
        --streak.alpha = 0
        streakText[i] = streak
        scrollView:insert(streak)

        if (nextIsTied == true) then
            rank.text = rank.text - 1
            rankCounter = rankCounter - 1
            -- streakText[i].alpha = 1
            -- streak.alpha = 1
        end

        if(returnFromFirebase[i+1].isTied == true) then
            nextIsTied = true
            print("rankCounter"..rankCounter)
            print("score"..returnFromFirebase[i+1].highscore)
            print(returnFromFirebase[i+1].isTied)
        elseif(returnFromFirebase[i+1].isTied == false) then
            nextIsTied = false
        end
        

    end
    -- local textObject = display.newText(text, 0, 0, contentWidth/1.1, 0, "Helvetica", 30)
    -- textObject:setTextColor(0)
    -- textObject.anchorY = 0
    -- textObject.x = centerX
    -- textObject.y = topScreen - centerY/4
    -- scrollView:insert(textObject)

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
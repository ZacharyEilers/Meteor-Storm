local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local names = {"John", "Sally", "Tim", "Zachary", "Grace", "Kylee", "Wes", "Evan", "Susanna", "Bradley"}

    namesMaxIndex = table.maxn(names)


    local globalLeaderboard = {}

    local usernames = {}

    local alphabet = "abcdefghijklmnopqrstuvwxyz"

    for i=1,string.len(alphabet) do
        --print(i)
       -- print(alphabet:sub(i,i))
       for j=1, string.len(alphabet) do
            usernames[alphabet:sub(i,i)..alphabet:sub(j,j)] = {}
       end
       
    end

    for i=1,100000 do
        local name = ""
            for i=1,10 do
                local strIndex = math.random(1, 26)
                name = name..alphabet:sub(strIndex, strIndex)
            end
           --print(usernames[name:sub(1,1)])
           table.insert(usernames[name:sub(1, 1)..name:sub(2,2)], #usernames[name:sub(1, 1)..name:sub(2,2)] + 1, name)
    end
     
   for i=1,string.len(alphabet) do
        --print(i)
       -- print(alphabet:sub(i,i))
       for j=1, string.len(alphabet) do

            for i=1, #usernames[alphabet:sub(i,i)..alphabet:sub(j,j)] do
                print(#usernames[alphabet:sub(i,i)..alphabet:sub(j,j)].."\n")
                print(i)
                print(usernames[alphabet:sub(i,i)..alphabet:sub(j,j)][i])
            end
            print("\n-------------------------------\n")
            
       end
       
    end



    -- for i=1, 500000 do
    --     globalLeaderboard[i] = {username = names[math.random(1, namesMaxIndex)], score =  math.random(0, 500)}
    -- end
    
    --     local function compare( a, b )
    --         return a.score > b.score  -- Note ">" as the operator
    --     end
         
    --     table.sort(globalLeaderboard, compare)

    --     local sum = 0
    -- for i= 1, 500000 do
    --     --print(i.."  "..globalLeaderboard[i].score)
    --     sum=sum+globalLeaderboard[i].score
    -- end
    -- local avg = sum/5000
    -- print(avg)
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
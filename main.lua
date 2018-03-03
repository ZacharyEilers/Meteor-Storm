-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

--constants

centerX = display.contentWidth*0.5
centerY = display.contentHeight*0.5
contentHeight = display.contentHeight
contentWidth = display.contentWidth

topScreen = display.screenOriginY
leftScreen =  display.screenOriginX
rightScreen = display.viewableContentWidth  - leftScreen
bottomScreen = display.viewableContentHeight - topScreen

--hide the status bar
display.setStatusBar( display.HiddenStatusBar )

--hide the virtual home buttons on android
native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )

--load up the audio
meteorHit = audio.loadSound("audio/DistantExplosion.wav")
earthHit = audio.loadSound("audio/DistantExplosion.wav")

--set the font
font = "Bungee-Regular"
altFont = "RobotoCondensed-Regular"
altFontBold = "RobotoCondensed-Bold"

usernameFont = "Montserrat-Black"

--some other game constants
sceneSwitchButtonWaitTime = 100

local composer = require "composer"

loadsave = require "loadsave"

--include the load/save library from corona rob
user = loadsave.loadTable("user.json")
if(user == nil) then 
	user = {}
	user.money = 100
	user.username = ""
	user.playsound = true
	user.best = 0
	user.streakBest = 0
	user.vibrate = true
	user.showBestText = true
	user.newUser = true

	loadsave.saveTable(user, "user.json")
end

-- composer.gotoScene("scene_credits")

if (user.newUser == false) then
	composer.gotoScene("scene_menu")
else
	composer.gotoScene("scene_intro")
end


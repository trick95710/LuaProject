-- set screen width and height
screen_width  = application:getContentWidth()
screen_height = application:getContentHeight()
center_width  = application:getContentWidth()/2
center_height = application:getContentHeight()/2

-- set font
scorefont = TTFont.new("font/SentyChalk.ttf", 20, true)
-- set debug 
debugRound = true

-- set reRound = "P1" then
-- is P1 turn
-- set reRound = "P2" then
-- is P2 turn
Round = "P1"

-- CountRound
CountRound = 4
-- GameEndRound
GameEndRound = 16

-- debugDraw show
debugDraw = true

-- BoxScore
blueboxScore = 30
purpleboxScore = 50
redboxScore = 20
greenboxScore = 5
pinkboxScore = 8 
whiteboxScore = 10
-----------
-- negative scorefont
neblueboxScore = -blueboxScore
nepurpleboxScore = -purpleboxScore
neredboxScore = -redboxScore
negreenboxScore = -greenboxScore
nepinkboxScore = -pinkboxScore 
newhiteboxScore = -whiteboxScore

---------------------

-- set reRound = 6 then setBox
setBox = true

-- set Button Picture
imgUp = "picture/button_Up.png"
imgDown = "picture/button_Down.png"

-- set BackBtnSize
backBtnScaleX = .7
backBtnScaleY = .7

-- set BigBtnSize and font Size
BigBtnScaleX = 1.3
BigBtnScaleY = 1.3
BigBtnFontSize = TTFont.new("font/kaiu.ttf", 17,true)

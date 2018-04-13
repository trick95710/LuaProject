-- set screen width and height
screen_width  = application:getContentWidth()
screen_height = application:getContentHeight()
center_width  = application:getContentWidth()/2
center_height = application:getContentHeight()/2

-- set font
scorefont = TTFont.new("font/SentyChalk.ttf", 20, true)
-- set debug 
debugRound = false

-- set reRound = "P1" then
-- is P1 turn
-- set reRound = "P2" then
-- is P2 turn
Round = "P1"

-- CountRound
CountRound = 1
-- GameEndRound
GameEndRound = 16

-- debugDraw show
debugDraw = false


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
imgUp = "picture/ButtonUp.png"
imgDown = "picture/ButtonDown.png"

-- set BackBtnSize
backBtnScaleX = .7
backBtnScaleY = .7

-- set BigBtnSize and font Size
BigBtnScaleX = 1.3
BigBtnScaleY = 1.3
BigBtnFontSize = TTFont.new("font/kaiu.ttf", 17,true)

ballrule = Bitmap.new(Texture.new("picture/Rules/ballrule.png"))
RoundBoxrule = Bitmap.new(Texture.new("picture/Rules/RoundBoxrule.png"))
groundrule = Bitmap.new(Texture.new("picture/Rules/groundrule.png"))
bafflerule = Bitmap.new(Texture.new("picture/Rules/bafflerule.png"))
Redboardrule = Bitmap.new(Texture.new("picture/Rules/Redboardrule.png"))
Grayboardrule = Bitmap.new(Texture.new("picture/Rules/Grayboardrule.png"))
Round6 = Bitmap.new(Texture.new("picture/Rules/Round6.png"))
JudgeBall = Bitmap.new(Texture.new("picture/Rules/JudgeBall.png"))
startrule = Bitmap.new(Texture.new("picture/Rules/startrule.png"))

--require "Config"
GameEnd = gideros.class(Sprite)

function GameEnd:init()
	
	GameEndfont = TTFont.new("font/W1.ttc", 60, true)
	
	local TextColor = 0xcdceb9
	
	SetX = 115
	SetY = 130
	
	-- create background
	local bg = Bitmap.new(Texture.new("picture/GameEndPicture.jpg"))
	self:addChildAt(bg,1)
	
	print(User)
	
	if debugRound and User == nil then
		score_P1 = 0
		score_P2 = 0
		
		User = "P1"
	end
	
	local ShowWinText =""
	local ShowScoreText = ""
	local ShowPlayerScore =""
	if User == "P1" then
		if score_P1 > score_P2 then
			ShowWinText = "You Win!!"
			ShowScoreText = "得分：" .. score_P1
			ShowPlayerScore = "對手：" .. score_P2
		elseif score_P1 < score_P2 then
			ShowWinText = "You Lose!!"
			ShowScoreText = "得分：" .. score_P1
			ShowPlayerScore = "對手：" .. score_P2
		elseif score_P1 == score_P2 then
			ShowWinText = "Deuces !!"
			ShowScoreText = "得分：" .. score_P1
			ShowPlayerScore = "對手：" .. score_P2
		end
	elseif User == "P2" then
		if score_P1 > score_P2 then
			ShowWinText = "You Lose!!"
			ShowScoreText = "得分：" .. score_P2
			ShowPlayerScore = "對手：" .. score_P1
		elseif score_P1 < score_P2 then
			ShowWinText = "You Win!!"
			ShowScoreText = "得分：" .. score_P2
			ShowPlayerScore = "對手：" .. score_P1
		elseif score_P1 == score_P2 then
			ShowWinText = "Deuces !!"
			ShowScoreText = "得分：" .. score_P2
			ShowPlayerScore = "對手：" .. score_P1
		end
	end
	
	local GameEndText = TextField.new(TTFont.new("font/W1.ttc", 100, true), "分數結算")
	GameEndText:setTextColor(TextColor)
	GameEndText:setPosition(SetX-75,SetY-50)
	self:addChild(GameEndText)
	
	local show_Win = TextField.new(GameEndfont, ShowWinText)
	show_Win:setTextColor(TextColor)
	show_Win:setPosition(SetX,SetY-10)
	self:addChild(show_Win)
	
	local show_Score = TextField.new(GameEndfont, ShowScoreText)
	show_Score:setTextColor(TextColor)
	show_Score:setPosition(SetX,SetY+30)
	self:addChild(show_Score)
	
	local show_Player_Score = TextField.new(GameEndfont, ShowPlayerScore)
	show_Player_Score:setTextColor(TextColor)
	show_Player_Score:setPosition(SetX,SetY+60)
	self:addChild(show_Player_Score)

	
	
	-- create button
	local Menubutton = Button.new(imgUp, imgDown, "主選單")
	Menubutton:setPosition(235,225)
	Menubutton:addEventListener("click", function()
		sceneManager:changeScene("start", 1, SceneManager.fade, easing.linear) 
	end)
	self:addChild(Menubutton)
	


-----------------------------------------------------------------------
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function GameEnd:onTransitionInBegin()
	print("GameEnd - enter begin")
end

function GameEnd:onTransitionInEnd()
	print("GameEnd - enter end")
end

function GameEnd:onTransitionOutBegin()
	print("GameEnd - exit begin")
end

function GameEnd:onTransitionOutEnd()
	print("GameEnd - exit end")
end
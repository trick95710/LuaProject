require "Config"
GameEnd = gideros.class(Sprite)

function GameEnd:init()
	
	-- create background
	local bg = Bitmap.new(Texture.new("picture/GameEndPicture.jpg"))
	self:addChildAt(bg,1)
	
	print(User)
	
	if debugRound and User == nil then
		score_P1 = 1
		score_P2 = 0
		
		User = "P1"
	end
	
	
	if User == "P1" then
		if score_P1 > score_P2 then
			local show_User = TextField.new(scorefont, "\t you Win fraction:".. score_P1.. "\n P2 fraction:".. score_P2)
			show_User:setPosition(25,150)
			self:addChild(show_User)
		elseif score_P1 < score_P2 then
			local show_User = TextField.new(scorefont, "\t you Lose fraction:".. score_P1.. "\n P2 fraction:".. score_P2)
			show_User:setPosition(25,150)
			self:addChild(show_User)
		end
	elseif User == "P2" then
		if score_P1 > score_P2 then
			local show_User2 = TextField.new(scorefont, "\t you Win fraction:".. score_P2.."\n P1 fraction:".. score_P1)
			show_User2:setPosition(30,150)
			self:addChild(show_User2)
		elseif score_P1 < score_P2 then
			local show_User2 = TextField.new(scorefont, "\t you Lose fraction:".. score_P2.." \n P1 fraction:".. score_P1)
			show_User2:setPosition(30,150)
			self:addChild(show_User2)
		end
	end
	
	local GameOver = Bitmap.new(Texture.new("picture/GameOver.png"))
	GameOver:setPosition(100,25)
    self:addChild(GameOver)
	
	
	-- create button
	local Menubutton = Button.new(imgUp, imgDown, "主選單")
	Menubutton:setPosition(225,225)
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
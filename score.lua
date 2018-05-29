score = Core.class(Sprite)

function score:init()
	
	-- create background
	local bg = Bitmap.new(Texture.new("picture/startpicture.jpg"))
	self:addChildAt(bg,1)
	
	local ScoreText = TextField.new(TTFont.new("font/W1.ttc", 50, true), "分數")
	ScoreText:setTextColor(0x000)
	ScoreText:setPosition(center_height-40,50)
	self:addChild(ScoreText)
	
	
	NewScore = getData("NewScore")

	if NewScore then
		i = 1
		while i <= #NewScore and i <= 25 do
			local Score = TextField.new(BigBtnFontSize, NewScore[i].. NewScore[i+1] .."   ".. NewScore[i+2]..NewScore[i+3].. "    "..NewScore[i+4])
			Score:setTextColor(0x8c0eba)
			Score:setPosition(100,80+i*5)
			self:addChild(Score)
			i = i + 5
		end	
	end
	
	local clearBtn = Button.new(imgUp, imgDown, "清除紀錄")
	clearBtn:setScale(.7,.7)
	clearBtn:setPosition(center_height-70,250)
	clearBtn:addEventListener("click", function()
		-- it should be used on Android only.
		clearScore()
		sceneManager:changeScene("score", 1, SceneManager.fade, easing.linear)
	end)
	self:addChild(clearBtn)
	
	BackStart.new(self, center_height+70 , 250)
	
	print(os.date("%Y-%m-%d %H:%M:%S"))
	
-- Get in or out to enter down of all the function
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function score:onTransitionInBegin()
	print("score - enter begin")
end

function score:onTransitionInEnd()
	print("score - enter end")
end

function score:onTransitionOutBegin()
	print("score - exit begin")
end

function score:onTransitionOutEnd()
	print("score - exit end")
end
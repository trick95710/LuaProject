start = Core.class(Sprite)

function start:init()

	local menu = VerticalView.new({padding = 10, easing = easing.outBounce})
	
	self:addChild(menu)
	
	-- create button
	
	local Startbutton = Button.new(imgUp, imgDown, "開始遊戲")
	--Startbutton:setPosition(center_height,center_width-70)
	Startbutton:addEventListener("click", function()
		sceneManager:changeScene("Rule", 1, SceneManager.fade, easing.linear) 
	end)
	menu:addChild(Startbutton)
	
	local SetButton = Button.new(imgUp, imgDown, "設定")
	--SetButton:setPosition(center_height,center_width)
	SetButton:addEventListener("click", function()
		sceneManager:changeScene("options", 1, SceneManager.fade, easing.linear) 
	end)
	menu:addChild(SetButton)
	
	
	
	local score = Button.new(imgUp, imgDown, "歷史紀錄")
	--endButton:setPosition(center_height,center_width+70)
	score:addEventListener("click", function()
		-- it should be used on Android only.
		sceneManager:changeScene("score", 1, SceneManager.fade, easing.linear) 
	end)
	menu:addChild(score)
	
	local GameEndText = TextField.new(TTFont.new("font/Barrelhouse All Caps.ttf", 50, true), "Ball Shooter")
	GameEndText:setTextColor(0xad0808)
	GameEndText:setPosition(30,80)
	self:addChild(GameEndText)
	
	
	-- create background
	local bg = Bitmap.new(Texture.new("picture/startpicture.jpg"))
	self:addChildAt(bg,1)
	
	menu:setPosition(center_height,center_width)
	
	local debugtext = TextField.new(nil, "debugMode On")
	debugtext:setPosition(23, 50)
	

	
	local debug_true = Button.new("picture/Transparent.png", "picture/Transparent.png", "")
	debug_true:setPosition(0,-15)
	self:addChild(debug_true)
	debug_true:addEventListener("click", 
		function()	
			if debugRound == false then
				debugRound = true
				self:addChild(debugtext)
			end
		end
	)
	
	
-- Get in or out to enter down of all the function
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function start:onTransitionInBegin()
	print("start - enter begin")
end

function start:onTransitionInEnd()
	print("start - enter end")
end

function start:onTransitionOutBegin()
	print("start - exit begin")
end

function start:onTransitionOutEnd()
	print("start - exit end")
end

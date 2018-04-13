Rule = Core.class(Sprite)

function Rule:init()

	debugGOP1 = 0
	debugGOP2 = 0
	
	-- create background
	local bg = Bitmap.new(Texture.new("picture/Rules/RulePicture.jpg"))
	self:addChildAt(bg,1)
	
	local slider = AceSlide.new({
		orientation = "horizontal",
		spacing = 100,
		speed = 5,
		unfocusedAlpha = 0.75,
		easing = nil,
		allowDrag = false,
		dragOffset = 10
	})
	
	self:addChild(slider)

	--create 10 boxes
	slider:add(startrule)
	slider:add(Redboardrule)
	slider:add(Grayboardrule)
	slider:add(RoundBoxrule)
	slider:add(groundrule)
	slider:add(ballrule)
	slider:add(JudgeBall)
	slider:add(Round6)
	slider:add(bafflerule)
	
	local Final = 9
	

	--just to show as example
	--of modifying all elements
	slider:applyToAll(function(elem)
		elem:setScale(1)
	end)

	--display slider
	slider:show()
	
	
	local Ipconnectbutton = Button.new(imgUp, imgDown, "連線")
	Ipconnectbutton:setPosition(center_height,center_width+120)
	Ipconnectbutton:addEventListener("click", function()
		sceneManager:changeScene("Ipconnect", 1, SceneManager.fade, easing.linear) 
	end)
	--self:addChild(Startbutton)
	
	
	--create buttons to switch content
	local rightButton = Button.new(imgButton_Up, imgButton_Down, "")
	rightButton:setPosition(480-70,160)
	rightButton:setScale(imgScaleX,imgScaleY)
	self:addChild(rightButton)
	rightButton:addEventListener("click", 
		function()	
			beforeItem = getItem
			getItem = slider:nextItem()
			print(getItem)
			if beforeItem == Final-1 and getItem == Final then
				self:addChild(Ipconnectbutton)
			end
		end
	)

	local leftButton = Button.new(imgButton_Up, imgButton_Down, "")
	leftButton:setPosition(70,160)
	leftButton:setScale(imgScaleX,imgScaleY)
	leftButton:setRotation(180)
	self:addChild(leftButton)
	leftButton:addEventListener("click", 
		function()	
			beforeItem = getItem
			getItem = slider:prevItem()
			print(getItem)
			if beforeItem == Final and getItem == Final-1 then
				self:removeChild(Ipconnectbutton)
			end
		end
	)
	
	BackBtn = BackStart.new(self)
	
	local debug_GOP1 = Button.new("picture/Transparent.png", "picture/Transparent.png", "")
	debug_GOP1:setPosition(0,-15)
	self:addChild(debug_GOP1)
	debug_GOP1:addEventListener("click", 
		function()	
			if debugRound then
				debugGOP1 = debugGOP1 +1
				if debugGOP1 == 10 then
					sceneManager:changeScene("P1_GAMESTART", 1, SceneManager.fade, easing.linear) 
				end
			end
		end
	)
	
	local debug_GOP2 = Button.new("picture/Transparent.png", "picture/Transparent.png", "")
	debug_GOP2:setPosition(screen_height,-15)
	self:addChild(debug_GOP2)
	debug_GOP2:addEventListener("click", 
		function()	
			if debugRound then
				debugGOP2 = debugGOP2 +1
				print(debugGOP2)
				if debugGOP2 == 10 then
					sceneManager:changeScene("P1_GAMESTART", 1, SceneManager.fade, easing.linear) 
				end
			end
		end
	)
	
-- Get in or out to enter down of all the function
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function Rule:onTransitionInBegin()
	print("Rule - enter begin")
end

function Rule:onTransitionInEnd()
	print("Rule - enter end")
end

function Rule:onTransitionOutBegin()
	print("Rule - exit begin")
end

function Rule:onTransitionOutEnd()
	print("Rule - exit end")
end

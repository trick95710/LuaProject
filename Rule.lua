Rule = Core.class(Sprite)

function Rule:init()
	
	-- create background
	local bg = Bitmap.new(Texture.new("picture/Rules/RulePicture.jpg"))
	self:addChildAt(bg,1)
	
	local slider = AceSlide.new({
		orientation = "horizontal",
		spacing = 100,
		speed = 5,
		unfocusedAlpha = 0.75,
		easing = nil,
		allowDrag = true,
		dragOffset = 10
	})
	
	self:addChild(slider)

	--create 10 boxes
	for i = 1, 10 do
		local box = Bitmap.new(Texture.new("picture/crate.png"))
		slider:add(box)
	end

	--just to show as example
	--of modifying all elements
	slider:applyToAll(function(elem)
		elem:setScale(1)
	end)

	--display slider
	slider:show()
	
	
	local Ipconnectbutton = Button.new(imgUp, imgDown, "連線")
	Ipconnectbutton:setPosition(center_height,center_width+70)
	Ipconnectbutton:addEventListener("click", function()
		sceneManager:changeScene("Ipconnect", 1, SceneManager.fade, easing.linear) 
	end)
	--self:addChild(Startbutton)
	

	local imgButton_Up = "picture/Rules/right-up.png"
	local imgButton_Down = "picture/Rules/right-down.png"
	
	local imgScaleX = .2
	local imgScaleY = .2
	--create buttons to switch content
	local rightButton = Button.new(imgButton_Up, imgButton_Down, "")
	rightButton:setPosition(480-70,160)
	rightButton:setScale(imgScaleX,imgScaleY)
	self:addChild(rightButton)
	rightButton:addEventListener("click", 
		function()	
			beforeItem = getItem
			getItem = slider:nextItem()
			if beforeItem == 9 and getItem == 10 then
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
			if beforeItem == 10 and getItem == 9 then
				self:removeChild(Ipconnectbutton)
			end
		end
	)
	
	BackBtn = BackStart.new(self)
	
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

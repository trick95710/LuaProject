Rules = Core.class(Sprite)

function Rules:init()
	
	-- create background
	local bg = Bitmap.new(Texture.new("picture/Rules/RulePicture.jpg"))
	self:addChildAt(bg,1)
	
	AceSlide.init({
		orientation = "horizontal",
		spacing = 100,
		parent = self,
		speed = 5,
		unfocusedAlpha = 0.75,
		easing = nil,
		allowDrag = true,
		dragOffset = 10
	})

	--create 10 boxes
	for i = 1, 10 do
		local box = Bitmap.new(Texture.new("picture/crate.png"))
		AceSlide.add(box)
	end

	--just to show as example
	--of modifying all elements
	AceSlide.applyToAll(function(elem)
		elem:setScale(2)
	end)

	--display slider
	AceSlide.show()


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
			AceSlide.nextItem()
		end
	)

	local leftButton = Button.new(imgButton_Up, imgButton_Down, "")
	leftButton:setPosition(70,160)
	leftButton:setScale(imgScaleX,imgScaleY)
	leftButton:setRotation(180)
	self:addChild(leftButton)
	leftButton:addEventListener("click", 
		function()	
			AceSlide.prevItem()
		end
	)
	
	BackBtnIp = BackStart.new(self, center_height, 300 , 1 , 1)
	
-- Get in or out to enter down of all the function
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function Rules:onTransitionInBegin()
	print("Rules - enter begin")
end

function Rules:onTransitionInEnd()
	print("Rules - enter end")
end

function Rules:onTransitionOutBegin()
	print("Rules - exit begin")
end

function Rules:onTransitionOutEnd()
	print("Rules - exit end")
end

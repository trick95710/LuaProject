Rules = Core.class(Sprite)

function Rules:init()
	
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


	local imgButton_Up = "picture/left-up.png"
	local imgButton_Down = "picture/left-down.png"
	

	--create buttons to switch content
	local leftButton = Button.new(imgButton_Up, imgButton_Down, "")
	leftButton:setPosition(70,130+58)
	leftButton:setAnchorPoint(.5,.5)
	self:addChild(leftButton)
	leftButton:addEventListener("click", 
		function()	
			AceSlide.prevItem()
		end
	)

	local rightButton = Button.new(imgButton_Up, imgButton_Down, "")
	rightButton:setPosition(480-70,130)
	rightButton:setAnchorPoint(.5,.5)
	rightButton:setRotation(180)
	self:addChild(rightButton)
	rightButton:addEventListener("click", 
		function()	
			AceSlide.nextItem()
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

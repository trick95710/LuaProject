Rules = Core.class(Sprite)

function Rules:init()
	
	-- create background
	local bg = Bitmap.new(Texture.new("picture/Rules/RulePicture.jpg"))
	self:addChildAt(bg,1)
	
	local slider = AceSlide.new({
		orientation = "",
		spacing = 100,
		speed = 5,
		unfocusedAlpha = 0.75,
		easing = nil,
		allowDrag = true,
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

	--just to show as example
	--of modifying all elements
	slider:applyToAll(function(elem)
		elem:setScale(1)
	end)

	--display slider
	slider:show()

	local ArrowUp = Bitmap.new(Texture.new("picture/Arrow.png"))
	ArrowUp:setScale(.1,.1)
	ArrowUp:setAnchorPoint(.5,.5)
	ArrowUp:setPosition(70,center_width)
	self:addChild(ArrowUp)

	local ArrowDown = Bitmap.new(Texture.new("picture/Arrow.png"))
	ArrowDown:setScale(.1,.1)
	ArrowDown:setAnchorPoint(.5,.5)
	ArrowDown:setRotation(180)
	ArrowDown:setPosition(410,center_width)
	self:addChild(ArrowDown)

	
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

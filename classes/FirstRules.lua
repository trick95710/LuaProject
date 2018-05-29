FirstRules = gideros.class(Sprite)

function FirstRules:init()
	
	--create layer for menu buttons
	local layer = Popup.new({easing = easing.outBack})
	layer:setFillStyle(Shape.SOLID, 0xaf5f5f, .9)
	layer:setLineStyle(.3, 0x8dd1f4)
	layer:setScale(0)
	self:addChild(layer)
		
		local slider = AceSlideCombinePopup.new({
			orientation = "horizontal",
			spacing = 100,
			speed = 5,
			unfocusedAlpha = 0.75,
			easing = nil,
			allowDrag = false,
			dragOffset = 10
		})
		layer:addChild(slider)
		
		
		local CancelButton = Button.new(imgUp, imgDown, "確定")
		CancelButton:setPosition(0,110)
		CancelButton:addEventListener("click", 
			function()
				layer:removeFromParent()
			end
		)
		layer:addChild(CancelButton)
		
		slider:add(startrule)
		slider:add(Redboardrule)
		slider:add(Grayboardrule)
		slider:add(RoundBoxrule)
		slider:add(groundrule)
		
		slider:applyToAll(function(elem)
			elem:setScale(1)
		end)
		
		slider:show()
		
		local rightButton = Button.new(imgButton_Up, imgButton_Down, "")
		rightButton:setPosition(200,0)
		rightButton:setScale(imgScaleX,imgScaleY)
		layer:addChild(rightButton)
		rightButton:addEventListener("click", 
			function()
				slider:nextItem()
			end
		)
		
		local leftButton = Button.new(imgButton_Up, imgButton_Down, "")
		leftButton:setPosition(-200,0)
		leftButton:setScale(imgScaleX,imgScaleY)
		leftButton:setRotation(180)
		layer:addChild(leftButton)
		leftButton:addEventListener("click", 
			function()	
				slider:prevItem()
			end
		)
		
	layer:show()
	
end
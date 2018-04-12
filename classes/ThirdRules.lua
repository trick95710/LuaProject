ThirdRules = gideros.class(Sprite)

function ThirdRules:init()
	
	--create layer for menu buttons
	local layer = Popup.new({easing = easing.outBack})
	layer:setFillStyle(Shape.SOLID, 0x0000ff, .5)
	layer:setLineStyle(5, 0x000000)
	layer:setScale(0)
	self:addChild(layer)
		
		local slider = AceSlideCombinePopup.new({
			orientation = "horizontal",
			spacing = 100,
			speed = 5,
			unfocusedAlpha = 0.75,
			easing = nil,
			allowDrag = true,
			dragOffset = 10
		})
		layer:addChild(slider)
		
		
		local CancelButton = Button.new(imgUp, imgDown, "確定")
		CancelButton:setPosition(0,100)
		CancelButton:addEventListener("click", 
			function()
				layer:removeFromParent()
			end
		)
		layer:addChild(CancelButton)
		
		for i = 1, 10 do
			local box = Bitmap.new(Texture.new("picture/crate.png"))
			slider:add(box)
		end
		
		slider:applyToAll(function(elem)
			elem:setScale(1)
		end)
		
		slider:show()
	layer:show()
	
end
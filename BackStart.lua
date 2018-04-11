--require "Config"
BackStart = Core.class(Sprite)

function BackStart:init(Scene, SetX , SetY , SetScaleX , SetScaleY)
	if SetX == nil then
		SetX = 50
	end
	if SetY == nil then
		SetY = screen_width-12.5
	end
	if SetScaleX == nil then
		SetScaleX = backBtnScaleX
	end
	if SetScaleY == nil then
		SetScaleY = backBtnScaleY
	end
	Back = Button.new(imgUp,imgDown, "返回")
	Back:setPosition(SetX , SetY)
	Back:setScale(SetScaleX,SetScaleY)
	Back:addEventListener("click",function() 
		sceneManager:changeScene("start", 1, SceneManager.fade, easing.linear) 
	end)
	Scene:addChild(Back)
end
ControlSound = Core.class(Sprite)

function ControlSound:init(Player, ControlSoundX , ControlSoundY ,name, BarSetVolume)
	if name.Volume == nil then
		name.Volume = channel:getVolume()
	end

	if BarSetVolume == nil then
		BarSetVolume = .5
	end
	name_ = name
	bar = Bitmap.new(Texture.new("picture/bar.png"),true)
	--bar:setAnchorPoint(.5,.5)
	marker = Bitmap.new(Texture.new("picture/marker.png"),true)
	--marker:setAnchorPoint(.5,.5)
	
	bar:setPosition(ControlSoundX , ControlSoundY)
	
	marker:setPosition(ControlSoundX-4 + (name.Volume*200) ,ControlSoundY-8)
	
	marker_Control_RangeX = ControlSoundX-4
	marker_Control_RangeY = ControlSoundY-8
	
	Player:addChild(bar)
	Player:addChild(marker)
	
	marker:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
    marker:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
    marker:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end

function ControlSound:onMouseDown(event)
	if marker:hitTestPoint(event.x, event.y) then
		marker.isFocus = true
		event:stopPropagation()
	end
end

function ControlSound:onMouseMove(event)
	if marker.isFocus then
		if event.x >= marker_Control_RangeX and event.x <= marker_Control_RangeX+199 then
			SetX = event.x
		elseif event.x < marker_Control_RangeX then
			SetX = marker_Control_RangeX
		elseif event.x > marker_Control_RangeX then
			SetX = marker_Control_RangeX +199
		end
		marker:setPosition(SetX,marker_Control_RangeY)
		name_.Volume =( marker:getX() - marker_Control_RangeX ) / 200
		event:stopPropagation()
	end
end

function ControlSound:onMouseUp(event)
	if marker.isFocus then
		marker.isFocus = false
		event:stopPropagation()
	end
end
options = Core.class(Sprite)

function options:init()
	
	-- create background
	local bg = Bitmap.new(Texture.new("picture/startpicture.jpg"))
	self:addChildAt(bg,1)
	
	ControlSound = ControlSound.new(self, center_height-100, center_width-12,self)
	
	SetVolumeTimer = Timer.new(100)
	SetVolumeTimer:addEventListener(Event.TIMER, function()
		channel:setVolume(self.Volume)
	end)
	SetVolumeTimer:start()
	
	BackBtn = BackStart.new(self)
	
	Soundfont = TTFont.new("font/SentyTang.ttf", 40, true)
	
	local SoundControlText = TextField.new(Soundfont, "音量控制")
	SoundControlText:setPosition(160,50)
	self:addChild(SoundControlText)
	
-- Get in or out to enter down of all the function
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function options:onTransitionInBegin()
	print("options - enter begin")
end

function options:onTransitionInEnd()
	print("options - enter end")
end

function options:onTransitionOutBegin()
	SetVolumeTimer:stop()
	print("options - exit begin")
end

function options:onTransitionOutEnd()
	print("options - exit end")
end
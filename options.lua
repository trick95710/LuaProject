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
	--[[
	-- CLOSE
	local SoundClose = Button.new(imgUp, imgDown, "音量關閉")
	SoundClose:setPosition(center_height,center_width)
	
	
	-- OPEN
	local SoundOpen = Button.new(imgDown, imgDown, "音量開啟")
	SoundOpen:setPosition(center_height,center_width)
	
	--SoundClose of Event
	SoundClose:addEventListener("click", function()
		Ifmusic = 1 
		music:off()
		print("music off")
		self:removeChild(SoundClose)
		self:addChild(SoundOpen)
		
	end)
	--self:addChild(READY)
	
	--SoundOpen of Event
	SoundOpen:addEventListener("click", function()
		Ifmusic = 0
		music:on()
		print("music on")
		self:removeChild(SoundOpen)
		self:addChild(SoundClose)
	end)
	--self:addChild(SoundOpen)
	
	
	if Ifmusic == 0 then
		
		self:addChild(SoundClose)
	elseif Ifmusic == 1 then 
		
		self:addChild(SoundOpen)
	end
	]]
	
	BackBtn = BackStart.new(self)
	
	--[[
	local backhome = Button.new(imgUp_2, imgDown_2, "首頁")
	backhome:setPosition(screen_height-25,screen_width-12.5)
	backhome:addEventListener("click", function()
		sceneManager:changeScene("start", 1, SceneManager.fade, easing.linear) 
	end)
	self:addChild(backhome)
	]]
	
	
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
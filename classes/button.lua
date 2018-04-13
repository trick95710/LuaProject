--[[
  Modified by LHC, 2017
--]]

Button = Core.class(Sprite)
local font = TTFont.new("font/kaiu.ttf", 20,true)
--local font = TTFont.new("tahoma.ttf", 30,true)
local textColorUp = 0xe81717;
local textColorDown = 0xfcfcfc;

--'value' is the text shown on button
--function Button:init(upState, downState, value)
function Button:init(upStateImgFile, downStateImgFile, value, changefont)
	self.upState = Bitmap.new(Texture.new(upStateImgFile), true)
	self.downState = Bitmap.new(Texture.new(downStateImgFile), true)
	self.upState:setAnchorPoint(0.5,0.5)
	self.downState:setAnchorPoint(0.5,0.5)
	if changefont == nil then
		changefont = font
	end
	
	if value then
		self.value = TextField.new(changefont,value);
		self.value:setTextColor( textColorUp )
		self.value:setAnchorPoint(0.5,-0.25);
	end
	self.focus = false
 
	-- set the visual state as "up"
	self:updateVisualState(false)
	if self.value and (not self:contains(self.value)) then
		self:addChild(self.value)
	end
 
	-- register to all mouse and touch events
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
 
	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
end
 
function Button:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.focus = true
		self:updateVisualState(true)
		event:stopPropagation()
	end
end
 
function Button:onMouseMove(event)
	if self.focus then
		if not self:hitTestPoint(event.x, event.y) then	
			self.focus = false
			self:updateVisualState(false)
		end
		event:stopPropagation()
	end
end
 
function Button:onMouseUp(event)
	if self.focus then
		self.focus = false
		self:updateVisualState(false)
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
	end
end
 
-- if button is on focus, stop propagation of touch events
function Button:onTouchesBegin(event)
	if self.focus then
		event:stopPropagation()
	end
end
 
-- if button is on focus, stop propagation of touch events
function Button:onTouchesMove(event)
	if self.focus then
		event:stopPropagation()
	end
end
 
-- if button is on focus, stop propagation of touch events
function Button:onTouchesEnd(event)
	if self.focus then
		event:stopPropagation()
	end
end
 
-- if touches are cancelled, reset the state of the button
function Button:onTouchesCancel(event)
	if self.focus then
		self.focus = false;
		self:updateVisualState(false)
		event:stopPropagation()
	end
end
 
-- if state is true show downState else show upState
function Button:updateVisualState(state)
	if state then
		if self:contains(self.upState) then
			self:removeChild(self.upState)
			if self.value and (self:contains(self.value)) then
				self:removeChild(self.value)
			end			
		end
 
		if not self:contains(self.downState) then
			self:addChild(self.downState)
			if self.value and ( not self:contains(self.value)) then
				self:addChild(self.value)
				self.value:setTextColor( textColorDown)
			end			
		end
	else
		if self:contains(self.downState) then
			self:removeChild(self.downState)
			if self.value and (self:contains(self.value)) then
				self:removeChild(self.value)
			end			
		end
 
		if not self:contains(self.upState) then
			self:addChild(self.upState)
			if self.value and ( not self:contains(self.value)) then
				self:addChild(self.value)
				self.value:setTextColor( textColorUp)
			end			
		end
	end
end
require "Config"
require "box2d"
P2_LEVEL2 = Core.class(Sprite)

User = "P2"

function P2_LEVEL2:init()

	--setRound_P2:stop()
	--drawtimer:stop()
	--[[
	-- show score
	score_P1 = 0
	score_P2 = 0]]

----------- UDP

	socket = require("socket")
	
	function LEVEL2_sendballPosition2()
		if theUdp then
			theUdp:sendto(ball2:getX().."/"..ball2:getY(),sendToIP, 9001)
		end
	end
	
	function LEVEL2_Post_Round_P2()
		if theUdp2 then
			theUdp2:sendto("1",sendToIP,8001)
		end
	end
	
	function LEVEL2_Post_draw_start_P2()
		if theUdp3 then
			theUdp3:sendto("0",sendToIP,7001)
		end
	end
	-- Post Score at 6001
	function LEVEL2_P2_Post_Score()
		if theUdp4 then
			theUdp4:sendto(score_P2,sendToIP,6001)
		end
	end
	
-- Set variable------------------------
-- set draw == 1 start to draw band_l && band_r
-- draw == 0 will stop  to draw
	drawNum = 1
	-- set P1 first
	reRound = 1
	-- Count touch ground
	CountGround = 1
	-- set Boxes Score
	BoxScore = 0
	-- CountRound
	CountRround = 6
	
----------- SendballPosition timer
	LEVEL2_postballposition_P2 = Timer.new(10)
	LEVEL2_postballposition_P2:addEventListener(Event.TIMER, function()
		LEVEL2_sendballPosition2()
		--print(ball:getPosition())
	end) 
----------- TIMER ------------------------------------------------
	LEVEL2_setballposition_P2 = Timer.new(10)
	LEVEL2_setballposition_P2:addEventListener(Event.TIMER, function()
		repeat
			if theUdp then
				local ip, port
				local reNew = true
				--repeat
					ballPosition, ip, port = theUdp:receivefrom()
					if ballPosition then
						if reNew then
							getXY = ballPosition:split()
							
							ball2:setPosition(getXY[1],getXY[2])
							reNew = false
						else
							--ball2:setY(ballPositionX)
							-------
						end
					end
				--until not ballPositionX
			end
		until not ballPosition
	end)
	LEVEL2_setballposition_P2:start()
	
	local ReduceDelay = 0
	
	LEVEL2_setRound_P2 = Timer.new(10)
	LEVEL2_setRound_P2:addEventListener(Event.TIMER, function()
		repeat
			if theUdp2 then
				local ip2, port2
				local reNew2 = true
					getRound , ip2 , port2 = theUdp2:receivefrom()
					if getRound then
						if reNew2 then
							reRound = tonumber(getRound)						
							print(reRound)
							reNew2 = false
						else
							
						end
					end		
			end
			if reRound == 1 then
					LEVEL2_postballposition_P2:stop()
					LEVEL2_Get_score_P1_Timer:start()
					LEVEL2_setballposition_P2:start()
					ReduceDelay = 1
			end
			if reRound == 0 then
				if ReduceDelay == 1 then
					self:score()
					ReduceDelay = 0 
				end
				Timer.delayedCall(400, function()
					LEVEL2_Get_score_P1_Timer:stop()
					LEVEL2_setballposition_P2:stop()
					LEVEL2_postballposition_P2:start()
					
				end)
			
			end
		until not getRound
	end)
	LEVEL2_setRound_P2:start()
	
	LEVEL2_drawtimer = Timer.new(10)
	LEVEL2_drawtimer:addEventListener(Event.TIMER, function()
		repeat 
			if theUdp3 then
				local ip3, port3
				local reNew3 = true
					getdraw , ip3 , port3 = theUdp3:receivefrom()
					if getdraw then
						if reNew3 then
							drawNum = tonumber(getdraw)
							self.band_l:clear()
							self.band_r:clear()
						else
							
						end
					end
			end
		until not getdraw
		
		if drawNum == 1 then
			LEVEL2_P2_draw()
		end
	end)
	LEVEL2_drawtimer:start()
	
	LEVEL2_Ball2isAwake_Timer = Timer.new(10)
	LEVEL2_Ball2isAwake_Timer:addEventListener(Event.TIMER,function()
		-- judge if ball exist
		if ball2_body then
			-- judge if ball is sleep
			if ball2_body:isAwake() == false then
				print("Ball is sleep")
				-- reset ball
				LEVEL2_P2_resetBall()
			end
		else
			-- ball not exist
			LEVEL2_Ball2isAwake_Timer:stop()
		end
	end)
	
	LEVEL2_Get_score_P1_Timer = Timer.new(10)
	LEVEL2_Get_score_P1_Timer:addEventListener(Event.TIMER,function()
		repeat
			if theUdp4 then
				local ip4 , port4
				local reNew4 = true
				GetP1Score , ip4 , port4 = theUdp4:receivefrom()
				if GetP1Score then
					if reNew4 then
						score_P1 = GetP1Score
						reNew4 = false
					else
						
					end
				end
				self:SetP1Score()
			end
		until not GetP1Score
	end)
	
----------------------------------------------------------------------

------- set world---------------------------------------------------------
	self.world = b2.World.new(0, 10, true)
	
------- set Boundary------------------------------------------------------
	local Boundary_down = b2.EdgeShape.new(0, screen_width, screen_height, screen_width)
	local Boundary_left = b2.EdgeShape.new(0, 0, 0, screen_width)
	local Boundary_right = b2.EdgeShape.new(0, 0, screen_height, 0)
	--local Boundary_up = b2.EdgeShape.new(screen_height, 0, screen_height, screen_width)
	local ground = self.world:createBody({})
	ground:createFixture({shape = Boundary_left,  density = 0.5,restitution = 0.6})
	ground:createFixture({shape = Boundary_right, density = 0.5,restitution = 0.3})
	--ground:createFixture({shape = Boundary_up, density = 0})
	ground:createFixture({shape = Boundary_down, density = 0.5,restitution = 0.8})
	ground.name = "ground"	
---------------------------------------------------------------------------


---------------function-----------------------------------------------
	function LEVEL2_P2_draw()
		local onBallBandX = ball2:getX() - ball2:getWidth()/2
		local onBallBandY = ball2:getHeight()/2
		self.band_l:clear()
		self.band_l = Shape.new()
		self.band_l:setFillStyle(Shape.SOLID, 0x382E1C)
		self.band_l:beginPath(Shape.NON_ZERO)
		-- up l
		self.band_l:lineTo(onBallBandX +8 , ball2:getY() - onBallBandY +5)
		--down l
		self.band_l:lineTo(onBallBandX +8 , ball2:getY() + onBallBandY -5)
		-- down r
		self.band_l:lineTo(85,250)
		-- up r
		self.band_l:lineTo(84,240)
		self.band_l:closePath()
		self.band_l:endPath()
		self:addChild(self.band_l)
		
		self.band_r:clear()
		self.band_r = Shape.new()
		self.band_r:setFillStyle(Shape.SOLID, 0x382E1C)
		self.band_r:beginPath(Shape.NON_ZERO)
		self.band_r:lineTo(onBallBandX +8 , ball2:getY() - onBallBandY +5)
		self.band_r:lineTo(onBallBandX +8 , ball2:getY() + onBallBandY -5)
		self.band_r:lineTo(110,250)
		self.band_r:lineTo(110,240)
		self.band_r:closePath()
		self.band_r:endPath()
		self:addChildAt(self.band_r, 3)	
	end
	function LEVEL2_P2_resetBall()
		
		-- show score
		self:resetScore()
		
		-- delete ball2
		ball2:removeFromParent()
		ball2.destroyBody = true
		Timer.delayedCall(.5, function()
			self.world:destroyBody(ball2_body)
			ball2_body= nil
		end)
		
		-- Post P1 Score to P2
		LEVEL2_P2_Post_Score()
		-- Post Round
		LEVEL2_Post_Round_P2()
		
		-- reset Ball
		ball2.isFly = false
		ball2 = Bitmap.new(Texture.new("picture/ball.png"),true)
		ball2:setPosition(103, screen_width-75)
		ball2:setAnchorPoint(.5,.5)
		ball2:setScale(.065,.065,.065)
		self:addChildAt(ball2,4)
		
		-- reset load Ball2 EventListener
		ball2:addEventListener(Event.MOUSE_DOWN, onMouseDown, self)
		ball2:addEventListener(Event.MOUSE_MOVE, onMouseMove, self)
		ball2:addEventListener(Event.MOUSE_UP, onMouseUp, self)
		
		-- draw band_l && band_r
		LEVEL2_P2_draw()
		
		Timer.delayedCall(200, function()
			-- set P1 Round
			reRound =1
			-- turn Round
			self:score()
			drawNum = 1
		end)
		
		-- reset variable--------
		CountGround = 1 
		BoxScore = 0
		-------------------------
		
		CountRround = CountRround + 1
		
		self:removeChild(RoundBoxText)
		
		RoundBoxText = TextField.new(LEVEL2_scorefont, CountRround)
		RoundBoxText:setPosition(218,43)
		self:addChild(RoundBoxText)
		
		if CountRround == 11 then
			sceneManager:changeScene("GameEnd", 1, SceneManager.fade, easing.linear)
		end
		print("LEVEL2_P2_LEVEL2 CountRround: " .. CountRround)
	end
----------- 畫面佈局：
	-- create background
	local bg = Bitmap.new(Texture.new("picture/bg5.jpg"))

	-- set font
	LEVEL2_scorefont = TTFont.new("font/setofont.ttf", 20, true)
	
	-- Round show
	--[[
	show_Round = TextField.new(scorefont, "對方的回合")
	show_Round:setPosition(20,20)
	self:addChild(show_Round)
	]]
	
	
	RoundBox = Bitmap.new(Texture.new("picture/RoundBox.png"))
	RoundBox:setPosition(190,0)
	RoundBox:setScale(.1,.1)
	
	RoundBoxText = TextField.new(LEVEL2_scorefont, CountRround)
	RoundBoxText:setPosition(218,43)
	self:addChild(RoundBoxText)
	
	-- if Your turn the board will be Redboard
	-- if Not your turn will be Grayboard
	-- set Redboard
	Redboard = Bitmap.new(Texture.new("picture/Redboard.png"))
	Redboard:setPosition(18,-55)
	Redboard:setScale(.2,.2)
	
	-- set Grayboard
	Grayboard = Bitmap.new(Texture.new("picture/Grayboard.png"))
	Grayboard:setPosition(250,-55)
	Grayboard:setScale(.2,.2)
	
	-- show P1 Score
	show_P1_word = TextField.new(LEVEL2_scorefont, "P1 Score :")
	show_P1_word:setTextColor(0x000000)
	show_P1_word:setPosition(50,45)
	self:addChild(show_P1_word)
	
	-- show P1 score on stage
	show_score_P1 = TextField.new(LEVEL2_scorefont, score_P1)
	show_score_P1:setTextColor(0x000000)
	show_score_P1:setPosition(70,65)
	self:addChild(show_score_P1)
	
	
	-- show P2 Score
	show_P2_word = TextField.new(LEVEL2_scorefont, "P2 Score :")
	show_P2_word:setTextColor(0x000000)
	show_P2_word:setPosition(280,45)
	self:addChild(show_P2_word)
	
	-- show P2 score on stage
	show_score_P2 = TextField.new(LEVEL2_scorefont, score_P2)
	show_score_P2:setPosition(300,65)
	self:addChild(show_score_P2)
	
	-- take the catapult in this picture
	local spritesheet = Texture.new("picture/spritesheet.png")
	-- take the ball of picture
	ball2 = Bitmap.new(Texture.new("picture/ball.png"),true)
	ball2:setScale(.065,.065,.065)
	ball2:setAnchorPoint(.5,.5)
	ball2:setPosition(103, screen_width-75)
	self.start_x, self.start_y = ball2:getPosition()
	
	
	------TextureRegion.new(BlueBox,X開始,Y開始,X結束,Y結束)	
	self.slingshot_r2 = Bitmap.new(TextureRegion.new(spritesheet, 3, 1, 37, 199))
	self.slingshot_l2 = Bitmap.new(TextureRegion.new(spritesheet, 834, 1, 43, 124))
	-- Place catapult
	self.slingshot_l2:setPosition(85, screen_width-94)
	self.slingshot_r2:setPosition(100, screen_width-90)
	
	-- picture to small 0.5
	setHalf({
		self.slingshot_r2,
		self.slingshot_l2
	})

	
	-- set Band-----------------------------------------------------------
	local onBallBandX = ball2:getX() - ball2:getWidth()/2
	local onBallBandY = ball2:getHeight()/2
	self.band_l = Shape.new()
	self.band_l:setFillStyle(Shape.SOLID, 0x382E1C)
	self.band_l:beginPath(Shape.NON_ZERO)
	self.band_l:lineTo(onBallBandX +8 , ball2:getY() - onBallBandY +5)
	self.band_l:lineTo(onBallBandX +8 , ball2:getY() + onBallBandY -5)
	self.band_l:lineTo(85,250)
	self.band_l:lineTo(84,240)
	self.band_l:closePath()
	self.band_l:endPath()
	
	self.band_r = Shape.new()
	self.band_r:setFillStyle(Shape.SOLID, 0x382E1C)
	self.band_r:beginPath(Shape.NON_ZERO)
	self.band_r:lineTo(onBallBandX +8 , ball2:getY() - onBallBandY +5)
	self.band_r:lineTo(onBallBandX +8 , ball2:getY() + onBallBandY -5)
	self.band_r:lineTo(110,250)
	self.band_r:lineTo(110,240)
	self.band_r:closePath()
	self.band_r:endPath()
	------------------------------------------------------------------------
	
	-- Add box on screen-----------------------------------------------------------------------
	-- Blue > Purple > red > green > pink > white
	-- Blue
	local BlueBox = Bitmap.new(Texture.new("picture/bluebox.png"))
	BlueBox:setScale(.2,.1924)
	BlueBox:setAnchorPoint(.5,.5)
	BlueBox:setPosition(screen_height-42.5*BlueBox:getScaleX(),277/2*BlueBox:getScaleY())
	
	local bluebox = self.world:createBody({})
	local boundary_bluebox = b2.EdgeShape.new(BlueBox:getX(), BlueBox:getY()-138.5*BlueBox:getScaleY(), BlueBox:getX(),BlueBox:getY()+138.5*BlueBox:getScaleY())
	bluebox:createFixture({shape = boundary_bluebox, density = 0})
	bluebox.name = "bluebox"
	--
	
	--Purple
	local Purplebox = Bitmap.new(Texture.new("picture/purplebox.png"))
	Purplebox:setScale(.2,.1924)
	Purplebox:setAnchorPoint(.5,.5)
	Purplebox:setPosition(screen_height-42.5*Purplebox:getScaleX(),BlueBox:getY()+277*BlueBox:getScaleY())
	
	local purplebox = self.world:createBody({})
	local boundary_purplebox = b2.EdgeShape.new(Purplebox:getX(), Purplebox:getY()-138.5*Purplebox:getScaleY(), Purplebox:getX(),Purplebox:getY()+138.5*Purplebox:getScaleY())
	purplebox:createFixture({shape = boundary_purplebox, density = 0})
	
	purplebox.name = "purplebox"
	--
	--red
	local Redbox = Bitmap.new(Texture.new("picture/redbox.png"))
	Redbox:setScale(.2,.1924)
	Redbox:setAnchorPoint(.5,.5)
	Redbox:setPosition(screen_height-42.5*Redbox:getScaleX(),Purplebox:getY()+277*Purplebox:getScaleY())
	
	local redbox = self.world:createBody({})
	local boundary_redbox = b2.EdgeShape.new(Redbox:getX(), Redbox:getY()-138.5*Redbox:getScaleY(), Redbox:getX(),Redbox:getY()+138.5*Redbox:getScaleY())
	redbox:createFixture({shape = boundary_redbox, density = 0})
	
	redbox.name = "redbox"
	--
	--green
	local Greenbox = Bitmap.new(Texture.new("picture/greenbox.png"))
	Greenbox:setScale(.2,.1924)
	Greenbox:setAnchorPoint(.5,.5)
	Greenbox:setPosition(screen_height-42.5*Greenbox:getScaleX(),Redbox:getY()+277*Redbox:getScaleY())
	
	local greenbox = self.world:createBody({})
	local boundary_greenbox = b2.EdgeShape.new(Greenbox:getX(), Greenbox:getY()-138.5*Greenbox:getScaleY(), Greenbox:getX(),Greenbox:getY()+138.5*Greenbox:getScaleY())
	greenbox:createFixture({shape = boundary_greenbox, density = 0})
	
	greenbox.name = "greenbox"
	--
	--pink
	local Pinkbox = Bitmap.new(Texture.new("picture/pinkbox.png"))
	Pinkbox:setScale(.2,.1924)
	Pinkbox:setAnchorPoint(.5,.5)
	Pinkbox:setPosition(screen_height-42.5*Pinkbox:getScaleX(),Greenbox:getY()+277*Greenbox:getScaleY())
	
	local pinkbox = self.world:createBody({})
	local boundary_pinkbox = b2.EdgeShape.new(Pinkbox:getX(), Pinkbox:getY()-138.5*Pinkbox:getScaleY(), Pinkbox:getX(),Pinkbox:getY()+138.5*Pinkbox:getScaleY())
	pinkbox:createFixture({shape = boundary_pinkbox, density = 0})
	
	pinkbox.name = "pinkbox"
	--
	--white
	local Whitebox = Bitmap.new(Texture.new("picture/whitebox.png"))
	Whitebox:setScale(.2,.1924)
	Whitebox:setAnchorPoint(.5,.5)
	Whitebox:setPosition(screen_height-42.5*Whitebox:getScaleX(),Pinkbox:getY()+277*Pinkbox:getScaleY())
	
	local whitebox = self.world:createBody({})
	local boundary_whitebox = b2.EdgeShape.new(Whitebox:getX(), Whitebox:getY()-138.5*Whitebox:getScaleY(), Whitebox:getX(),Whitebox:getY()+138.5*Whitebox:getScaleY())
	whitebox:createFixture({shape = boundary_whitebox, density = 0})
	
	whitebox.name = "whitebox"
	-----------------------------------------------------------------------------------------------
    

	self:addChildAt(bg,1)
	self:addChildAt(Redboard,2)
	self:addChildAt(Grayboard,2)
	self:addChildAt(self.slingshot_r2,2)
	self:addChildAt(RoundBox,2)
	self:addChildAt(self.band_r, 3)
	self:addChildAt(ball2,4)
	self:addChildAt(self.band_l, 5)
	self:addChildAt(self.slingshot_l2,6)
	
	self:addChildAt(BlueBox,3)
	self:addChildAt(Purplebox,3)
	self:addChildAt(Redbox,3)
	self:addChildAt(Greenbox,3)
	self:addChildAt(Pinkbox,3)
	self:addChildAt(Whitebox,3)
	
	
--------------------------------------------------------------------------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	ball2:addEventListener(Event.MOUSE_DOWN, LEVEL2_onMouseDown, self)
	ball2:addEventListener(Event.MOUSE_MOVE, LEVEL2_onMouseMove, self)
	ball2:addEventListener(Event.MOUSE_UP, LEVEL2_onMouseUp, self)
	
	self.world:addEventListener(Event.BEGIN_CONTACT, LEVEL2_P2_onBeginContact)
	
-- Get in or out to enter down of all the function
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function LEVEL2_P2_onBeginContact(event)
	-- you can get the fixtures and bodies in this contact like:
	local fixtureA = event.fixtureA
	local fixtureB = event.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	
	if ball2.destroyBody == false then
		if bodyB.name == "ball2" then
			LEVEL2_P2_box2d(bodyA.name)
			if  bodyA.name == "ground" then
				CountGround = CountGround + 1
			end
		end
		print("begin contact: "..bodyA.name.."<->"..bodyB.name)
	end
end

function setHalf(arr)
	for i = 1 ,#arr do
		arr[i]:setScale(.5,.5)
	end
end

function string:split(delimiter)
	if delimiter == nil then
		delimiter = "/"
	end
	local result = {}
	local from = 1
	local delim_form , delim_to = self:find(delimiter, from)
	while delim_form do
		table.insert(result, self:sub(from, delim_form-1))
		from = delim_to + 1
		delim_form , delim_to = self:find(delimiter , from)
	end
	table.insert(result, self:sub(from))
	return result
end

function LEVEL2_onMouseDown(self , event)
	print(reRound)
	
	if reRound == 0 then
		
		local bird = ball2
		if bird:hitTestPoint(event.x, event.y) and bird.isFly ~= true then
			bird.isFocus = true
			
			bird.x0, bird.y0 = event.x, event.y
			
			LEVEL2_postballposition_P2:start()
			
			event:stopPropagation()
		end
	end
end

function LEVEL2_onMouseMove(self , event)
	local bird = ball2
	if bird.isFocus then
		local AbsoluteRadius = 50
		local distanceX = event.x - self.start_x
		local distanceY = event.y - self.start_y
		local Radius = math.sqrt(distanceX*distanceX+distanceY*distanceY)
		
		local cosrad = distanceX / Radius
		
		local sinrad = distanceY / Radius
		
		if	Radius < AbsoluteRadius then
			bird:setPosition(event.x, event.y)
		elseif Radius >= AbsoluteRadius then
			local newX = cosrad*AbsoluteRadius
			local newY = sinrad*AbsoluteRadius
			ball2:setPosition(self.start_x + newX, self.start_y + newY)
		end
		
		
		LEVEL2_P2_draw()
		
		event:stopPropagation()
	end
end

function LEVEL2_onMouseUp(self , event)
	if ball2.isFocus and ball2.isFly ~= true then
	
		ball2.isFocus = false
		
		LEVEL2_Post_draw_start_P2()
		
		ball2_body = self.world:createBody{type = b2.DYNAMIC_BODY}
		circle_shape = b2.CircleShape.new(0, 0, ball2:getWidth() / 2)
		ball2_fixture = ball2_body:createFixture{shape = circle_shape, density = 1.0, friction = .5, restitution = 0}
			
		ball2.body = ball2_body
		ball2.body:setPosition(ball2:getX() , ball2:getY() )
		
		ball2.body:applyForce((self.start_x - ball2:getX()) * 22, (self.start_y - ball2:getY()) * 20, ball2.body:getWorldCenter())
		ball2_body.name = "ball2"
		ball2.isFly = true
		ball2.destroyBody = false
		self.band_l:clear()
		self.band_r:clear()
		
		
		LEVEL2_Ball2isAwake_Timer:start()
		
		event:stopPropagation()
	end
end

function LEVEL2_P2_box2d(decidebox)
	-- Blue > Purple > red > green > pink > white
	local box2d_switch = {
		["bluebox"] = function()
			BoxScore = 30
		end,
		["purplebox"] = function()
			BoxScore = 50
		end,
		["redbox"] = function()
			BoxScore = 20
		end,
		["greenbox"] = function()
			BoxScore = 5
		end,
		["pinkbox"] = function()
			BoxScore = 8
		end,
		["whitebox"] = function()
			BoxScore = 10
		end
	}
	
	local judge = box2d_switch[decidebox]
	if(judge) then
		judge()
		LEVEL2_P2_resetBall()
	else
		--
	end
end
function P2_LEVEL2:resetScore()
	-- reset Score
	self:removeChild(show_score_P2)
	-- calc score_P2
	score_P2 = score_P2 + (CountGround * BoxScore)
	-- reset score_P2
	show_score_P2 = TextField.new(LEVEL2_scorefont, score_P2)
	show_score_P2:setPosition(300,65)
	show_score_P2:setTextColor(0x000000)
	-- show
	self:addChild(show_score_P2)
end


function P2_LEVEL2:SetP1Score()
	self:removeChild(show_score_P1)
	show_score_P1 = TextField.new(LEVEL2_scorefont, score_P1)
	show_score_P1:setPosition(70,65)
	self:addChild(show_score_P1)
end

function setHalf(arr)
	for i = 1 ,#arr do
		arr[i]:setScale(.5,.5)
	end
end

function P2_LEVEL2:score()
	local switch = {
		[0] = function()    -- for case 0
			RoundText = "我方的回合"
			Redboard:setPosition(250,-55)
			Grayboard:setPosition(18,-55)
			self:addChildAt(Redboard,2)
			self:addChildAt(Grayboard,2)
		end,
		[1] = function()    -- for case 1
			RoundText = "對方的回合"
			Redboard:setPosition(18,-55)
			Grayboard:setPosition(250,-55)
			self:addChildAt(Redboard,2)
			self:addChildAt(Grayboard,2)
		end			
	}
	local Record = reRound
	local decide = switch[Record]
	if(decide) then
		self:removeChild(Redboard)
		self:removeChild(Grayboard)
		decide()
	else                -- for case default
		--print "Case default."
		RoundText = "發生錯誤"
	end
end


function P2_LEVEL2:onEnterFrame()
	self.world:step(1/60, 8, 3)


	for i = 1, self:getNumChildren() do
		local sprite = self:getChildAt(i)
		if sprite.body then
			local body = sprite.body
			local bodyX, bodyY = body:getPosition()
			sprite:setPosition(bodyX, bodyY)
			sprite:setRotation(body:getAngle() * 180 / math.pi)
		end
	end	
	
end
function P2_LEVEL2:onTransitionInBegin()
	print("P2_LEVEL2 - enter begin")
end

function P2_LEVEL2:onTransitionInEnd()
	print("P2_LEVEL2 - enter end")
end

function P2_LEVEL2:onTransitionOutBegin()
	print("P2_LEVEL2 - exit begin")
end

function P2_LEVEL2:onTransitionOutEnd()
	print("P2_LEVEL2 - exit end")
end
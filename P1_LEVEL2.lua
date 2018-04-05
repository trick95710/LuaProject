require "Config"
require "box2d"
P1_LEVEL2 = gideros.class(Sprite)

function P1_LEVEL2:init()
----------- UDP
	socket = require("socket")
	
	--setRound:stop()
	--drawtimer:stop()
	
	--[[
	score_P1 = 0
	score_P2 = 0
	]]
	function LEVEL2_sendballPosition()
		if theUdp then
			theUdp:sendto(ball:getX().."/"..ball:getY(),sendToIP, 9001)
		end
	end

	-- Post Round at 8001 , that can turn player 
	function LEVEL2_Post_Round()
		if theUdp2 then
			theUdp2:sendto("0",sendToIP,8001)
		end
	end

	-- Post start draw at 7001 
	function LEVEL2_Post_draw_start()
		if theUdp3 then
			theUdp3:sendto("0",sendToIP,7001)
		end
	end
	-- Post Score at 6001
	function LEVEL2_P1_Post_Score()
		if theUdp4 then
			theUdp4:sendto(score_P1,sendToIP,6001)
		end
	end
	
-- Set variable----------------------	--
	-- set draw == 1 start to draw band_l && band_r
	-- draw == 0 will stop  to draw
	drawNum = 0
	-- init is Round = 1
	reRound = 1
	-- Count touch ground
	CountGround = 1
	-- set Boxes Score
	BoxScore = 0
	-- CountRound
	CountRround = 6
----------------------------------------
----------- SendballPosition timer
	LEVEL2_postballposition = Timer.new(10)
	LEVEL2_postballposition:addEventListener(Event.TIMER, function()
		LEVEL2_sendballPosition()
	end) 
----------- Timer ------------------------------------------------------------
	LEVEL2_setballposition = Timer.new(10)
	LEVEL2_setballposition:addEventListener(Event.TIMER, function()
		repeat
			if theUdp then
				local ip, port
				local reNew = true
				--repeat
					ballPosition, ip, port = theUdp:receivefrom()
					if ballPosition then
						if reNew then
							getXY = ballPosition:split()
							
							ball:setPosition(getXY[1],getXY[2])
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
	
	local ReduceDelay = 0
	
	LEVEL2_setRound = Timer.new(10)
	LEVEL2_setRound:addEventListener(Event.TIMER, function()
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
			-- reRound == 0 for P2 
			-- P1 will stop post Ball and start get Ball
			if reRound == 0 then
					LEVEL2_postballposition:stop()
					LEVEL2_Get_score_P2_Timer:start()
					LEVEL2_setballposition:start()
					--reset For P2 turn P1 to do  
					-- if reRound == 1 && ReduceDelay == 1 
					ReduceDelay = 1
			end
			-- reRound == 1 for P1
			-- P1 will stop get Ball and start post Ball
			if reRound == 1 then
				if ReduceDelay == 1 then
					-- turn Round
					self:score()
					
					self:removeChild(RoundBoxText)
					
					RoundBoxText = TextField.new(scorefont, CountRround)
					RoundBoxText:setPosition(218,43)
					self:addChild(RoundBoxText)
					
					if CountRround == 11 then
						sceneManager:changeScene("GameEnd", 1, SceneManager.fade, easing.linear)
					end
					-- just in for once time
					ReduceDelay = 0 
				end
				-- have to delay to stop set ball
				-- that will be reset ball position
				Timer.delayedCall(500, function()
					LEVEL2_Get_score_P2_Timer:stop()
					LEVEL2_setballposition:stop()
					LEVEL2_postballposition:start()
				end)			
			end
		until not getRound
	end)
	LEVEL2_setRound:start()
	
	
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
							-- get getdraw will clean band_l && band_r
							self.band_l:clear()
							self.band_r:clear()
						else
							
						end
					end
			end
		until not getdraw
		
		-- if get drawNum == 1 to draw band_l && band_r
		if drawNum == 1 then
			LEVEL2_draw()
		end
	end)
	LEVEL2_drawtimer:start()
	
	
	LEVEL2_BallisAwake_Timer = Timer.new(10)
	LEVEL2_BallisAwake_Timer:addEventListener(Event.TIMER,function()
		-- judge if ball exist
		if ball_body then
			-- judge if ball is sleep
			if ball_body:isAwake() == false then
				print("Ball is sleep")
				-- reset ball
				LEVEL2_resetBall()
			end
		else
			-- ball not exist
			LEVEL2_BallisAwake_Timer:stop()
		end
	end)
	
	
	LEVEL2_Get_score_P2_Timer = Timer.new(10)
	LEVEL2_Get_score_P2_Timer:addEventListener(Event.TIMER,function()
		repeat
			if theUdp4 then
				local ip4 , port4
				local reNew4 = true
				GetP2Score , ip4 , port4 = theUdp4:receivefrom()
				if GetP2Score then
					if reNew4 then
						score_P2 = GetP2Score
						reNew4 = false
					else
						
					end
				end
				self:SetP2Score()
			end
		until not GetP2Score
	end)
	
	
	
	function LEVEL2_draw()
		local onBallBandX = ball:getX() - ball:getWidth()/2
		local onBallBandY = ball:getHeight()/2
		self.band_l:clear()
		self.band_l = Shape.new()
		self.band_l:setFillStyle(Shape.SOLID, 0x382E1C)
		self.band_l:beginPath(Shape.NON_ZERO)
		-- up l
		self.band_l:lineTo(onBallBandX +8 , ball:getY() - onBallBandY +5)
		--down l
		self.band_l:lineTo(onBallBandX +8 , ball:getY() + onBallBandY -5)
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
		self.band_r:lineTo(onBallBandX +8 , ball:getY() - onBallBandY +5)
		self.band_r:lineTo(onBallBandX +8 , ball:getY() + onBallBandY -5)
		self.band_r:lineTo(110,250)
		self.band_r:lineTo(110,240)
		self.band_r:closePath()
		self.band_r:endPath()
		self:addChildAt(self.band_r, 3)
	end
	
	function LEVEL2_resetBall()
		
		-- show score
		self:resetScore()
		
		-- delete ball
		ball:removeFromParent()
		ball.destroyBody = true
		Timer.delayedCall(.5, function()
			self.world:destroyBody(ball_body)
			ball_body= nil
		end)
		
		-- Post P1 Score to P2
		LEVEL2_P1_Post_Score()
		-- Post Round
		LEVEL2_Post_Round()
		
		-- reset Ball
		ball.isFly = false
		ball = Bitmap.new(Texture.new("picture/ball.png"),true)
		ball:setPosition(103, screen_width-75)
		ball:setAnchorPoint(.5,.5)
		ball:setScale(.065,.065,.065)
		self:addChildAt(ball,4)
		
		-- reset load Ball EventListener
		ball:addEventListener(Event.MOUSE_DOWN, onMouseClickDown, self)
		ball:addEventListener(Event.MOUSE_MOVE, onMouseClickMove, self)
		ball:addEventListener(Event.MOUSE_UP, onMouseClickUp, self)
		
		-- draw band_l && band_r
		LEVEL2_draw()
		
		Timer.delayedCall(200, function()
			-- set P2 Round
			reRound = 0
			-- turn Round
			self:score()
			drawNum = 1
			
			CountRround = CountRround + 1
			print("P1_GAMESTART CountRround: " .. CountRround)
		end)
		
		-- reset variable--------
		CountGround = 1 
		BoxScore = 0		
		-------------------------
	end
	---------------------------------------------------
	self.world = b2.World.new(0, 10, true)
	
	-- set Boundary
	local Boundary_down = b2.EdgeShape.new(0, screen_width, screen_height, screen_width)
	local Boundary_left = b2.EdgeShape.new(0, 0, 0, screen_width)
	local Boundary_right = b2.EdgeShape.new(0, 0, screen_height, 0)
	--local Boundary_up = b2.EdgeShape.new(screen_height, 0, screen_height, screen_width)
	
	local ground = self.world:createBody({})
	ground:createFixture({shape = Boundary_left, density = 0.5,restitution = 0.6})
	ground:createFixture({shape = Boundary_right, density = 0.5,restitution = 0.3})
	--ground:createFixture({shape = Boundary_up, density = 0})
	ground:createFixture({shape = Boundary_down, density = 0.5,restitution = 0.8})
	ground.name = "ground"
---------------------------------------------------------------------------
	
----- 畫面
	local background = Bitmap.new(Texture.new("picture/bg5.jpg"))
	
-- set font
	LEVEL_scorefont = TTFont.new("font/setofont.ttf", 20, true)
	
	
	RoundBox = Bitmap.new(Texture.new("picture/RoundBox.png"))
	RoundBox:setPosition(190,0)
	RoundBox:setScale(.1,.1)
	
	RoundBoxText = TextField.new(LEVEL_scorefont, CountRround)
	RoundBoxText:setPosition(218,43)
	self:addChild(RoundBoxText)
	
	
-- take the catapult in this picture 
	local spritesheet = Texture.new("picture/spritesheet.png")
	------TextureRegion.new(BlueBox,X開始,Y開始,X結束,Y結束)	
	self.slingshot_r = Bitmap.new(TextureRegion.new(spritesheet, 3, 1, 37, 199))
	self.slingshot_l = Bitmap.new(TextureRegion.new(spritesheet, 834, 1, 43, 124))
	-- Place catapult
	self.slingshot_l:setPosition(85, screen_width-94)
	self.slingshot_r:setPosition(100, screen_width-90)
	setHalf({
		self.slingshot_r,
		self.slingshot_l
	})
	
	
	-- set Ball
	ball = Bitmap.new(Texture.new("picture/ball.png"),true)
	ball:setPosition(103, screen_width-75)
	ball:setAnchorPoint(.5,.5)
	ball:setScale(.065,.065,.065)
	self.start_x, self.start_y = ball:getPosition()
	
	-- set Band --------------------------------------------------------
	local onBallBandX = ball:getX() - ball:getWidth()/2
	local onBallBandY = ball:getHeight()/2
	self.band_l = Shape.new()
	self.band_l:setFillStyle(Shape.SOLID, 0x382E1C)
	self.band_l:beginPath(Shape.NON_ZERO)
	self.band_l:lineTo(onBallBandX +8 , ball:getY() - onBallBandY +5)
	self.band_l:lineTo(onBallBandX +8 , ball:getY() + onBallBandY -5)
	self.band_l:lineTo(85,250)
	self.band_l:lineTo(84,240)
	self.band_l:closePath()
	self.band_l:endPath()
	
	
	self.band_r = Shape.new()
	self.band_r:setFillStyle(Shape.SOLID, 0x382E1C)
	self.band_r:beginPath(Shape.NON_ZERO)
	self.band_r:lineTo(onBallBandX +8 , ball:getY() - onBallBandY +5)
	self.band_r:lineTo(onBallBandX +8 , ball:getY() + onBallBandY -5)
	self.band_r:lineTo(110,250)
	self.band_r:lineTo(110,240)
	self.band_r:closePath()
	self.band_r:endPath()
	------------------------------------------------------------------------
	
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
	show_P1_word = TextField.new(LEVEL_scorefont, "P1 Score :")
	show_P1_word:setTextColor(0x000000)
	show_P1_word:setPosition(50,45)
	self:addChild(show_P1_word)
	
	-- show P1 score on stage
	show_score_P1 = TextField.new(LEVEL_scorefont, score_P1)
	show_score_P1:setTextColor(0x000000)
	show_score_P1:setPosition(70,65)
	self:addChild(show_score_P1)
	
	
	-- show P2 Score
	show_P2_word = TextField.new(LEVEL_scorefont, "P2 Score :")
	show_P2_word:setTextColor(0x000000)
	show_P2_word:setPosition(280,45)
	self:addChild(show_P2_word)
	
	-- show P2 score on stage
	show_score_P2 = TextField.new(LEVEL_scorefont, score_P2)
	show_score_P2:setPosition(300,65)
	self:addChild(show_score_P2)
	
	
	-- Add box on screen--------------------------------------------------------------------------------
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
	Purplebox:setPosition(screen_height-42.5*Purplebox:getScaleX(),BlueBox:getY()+277*BlueBox:getScaleY() )
	
	local purplebox = self.world:createBody({})
	local boundary_purplebox = b2.EdgeShape.new(Purplebox:getX(), Purplebox:getY()-138.5*Purplebox:getScaleY(), Purplebox:getX(),Purplebox:getY()+138.5*Purplebox:getScaleY())
	purplebox:createFixture({shape = boundary_purplebox, density = 0})
	
	purplebox.name = "purplebox"
	--
	--red
	local Redbox = Bitmap.new(Texture.new("picture/redbox.png"))
	Redbox:setScale(.2,.1924)
	Redbox:setAnchorPoint(.5,.5)
	Redbox:setPosition(screen_height-42.5*Redbox:getScaleX(),Purplebox:getY()+277*Purplebox:getScaleY() )
	
	local redbox = self.world:createBody({})
	local boundary_redbox = b2.EdgeShape.new(Redbox:getX(), Redbox:getY()-138.5*Redbox:getScaleY(), Redbox:getX(),Redbox:getY()+138.5*Redbox:getScaleY())
	redbox:createFixture({shape = boundary_redbox, density = 0})
	
	redbox.name = "redbox"
	--
	--green
	local Greenbox = Bitmap.new(Texture.new("picture/greenbox.png"))
	Greenbox:setScale(.2,.1924)
	Greenbox:setAnchorPoint(.5,.5)
	Greenbox:setPosition(screen_height-42.5*Greenbox:getScaleX(),Redbox:getY()+277*Redbox:getScaleY() )
	
	local greenbox = self.world:createBody({})
	local boundary_greenbox = b2.EdgeShape.new(Greenbox:getX(), Greenbox:getY()-138.5*Greenbox:getScaleY(), Greenbox:getX(),Greenbox:getY()+138.5*Greenbox:getScaleY())
	greenbox:createFixture({shape = boundary_greenbox, density = 0})
	
	greenbox.name = "greenbox"
	--
	--pink
	local Pinkbox = Bitmap.new(Texture.new("picture/pinkbox.png"))
	Pinkbox:setScale(.2,.1924)
	Pinkbox:setAnchorPoint(.5,.5)
	Pinkbox:setPosition(screen_height-42.5*Pinkbox:getScaleX(),Greenbox:getY()+277*Greenbox:getScaleY() )
	
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
	--
	----------------------------------------------------------------------------------------------------
	
	self:addChildAt(background,1)
	self:addChildAt(Redboard,2)
	self:addChildAt(Grayboard,2)
	self:addChildAt(self.slingshot_r,2)
	self:addChildAt(RoundBox,2)
	self:addChildAt(self.band_r,3)
	self:addChildAt(ball,4)
	self:addChildAt(self.band_l,5)
	self:addChildAt(self.slingshot_l,6)
	
	self:addChildAt(BlueBox,3)
	self:addChildAt(Purplebox,3)
	self:addChildAt(Redbox,3)
	self:addChildAt(Greenbox,3)
	self:addChildAt(Pinkbox,3)
	self:addChildAt(Whitebox,3)
	
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	ball:addEventListener(Event.MOUSE_DOWN, P1_LEVEL2MouseDown, self)
	ball:addEventListener(Event.MOUSE_MOVE, P1_LEVEL2MouseMove, self)
	ball:addEventListener(Event.MOUSE_UP, P1_LEVEL2MouseUp, self)
	
	self.world:addEventListener(Event.BEGIN_CONTACT, P1_LEVEL2_onBeginContact)
	
-----------------------------------------------------------------------
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end
function P1_LEVEL2_onBeginContact(event)
	-- you can get the fixtures and bodies in this contact like:
	local fixtureA = event.fixtureA
	local fixtureB = event.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	
	if ball.destroyBody == false then
		if bodyB.name == "ball" then
			LEVEL2_box2d(bodyA.name)
			if  bodyA.name == "ground" then
				CountGround = CountGround + 1
			end
		end
		print("begin contact: "..bodyA.name.."<->"..bodyB.name)
	end
end
function P1_LEVEL2MouseDown(self, event)
	print(reRound)
	if reRound == 1 then
		local bird = ball
		if bird:hitTestPoint(event.x, event.y) and bird.isFly ~= true then
			bird.isFocus = true
			
			bird.x0, bird.y0 = event.x, event.y
			
			
			LEVEL2_postballposition:start()
			event:stopPropagation()
		end
	end
end

function P1_LEVEL2MouseMove(self, event)
	-- if sprite touch and move finger, then change position of sprite
	local bird = ball
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
			ball:setPosition(self.start_x + newX, self.start_y + newY)
		end
		
		LEVEL2_draw()
		
		event:stopPropagation()
	end
end

function P1_LEVEL2MouseUp(self, event)
	if ball.isFocus and ball.isFly ~= true then
		
		ball.isFocus = false
		
		-- stop to draw
		LEVEL2_Post_draw_start()
		
		ball_body = self.world:createBody{type = b2.DYNAMIC_BODY}
		circle_shape = b2.CircleShape.new(0, 0, ball:getWidth() / 2)
		ball_fixture = ball_body:createFixture{shape = circle_shape, density = 1.0, friction = .5, restitution = 0}
		ball.body = ball_body
		ball.body:setPosition(ball:getX() , ball:getY() )
		
		ball.body:applyForce((self.start_x - ball:getX()) * 22, (self.start_y - ball:getY()) * 20, ball.body:getWorldCenter())
		ball_body.name = "ball"
		ball.isFly = true
		
		-- set ball is working
		ball.destroyBody = false
		
		self.band_l:clear()
		self.band_r:clear()
		
		LEVEL2_BallisAwake_Timer:start()
		
		event:stopPropagation()
	end
end

function LEVEL2_box2d(decidebox)
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
		LEVEL2_resetBall()
	else
		--
	end
end


function P1_LEVEL2:resetScore()
	-- reset Score
	self:removeChild(show_score_P1)
	-- calc score_P1
	score_P1 = score_P1 + (CountGround * BoxScore)
	-- reset score_P1
	show_score_P1 = TextField.new(LEVEL_scorefont, score_P1)
	show_score_P1:setPosition(70,65)
	show_score_P1:setTextColor(0x000000)
	-- show
	self:addChild(show_score_P1)
end
function P1_LEVEL2:SetP2Score()
	self:removeChild(show_score_P2)
	show_score_P2 = TextField.new(LEVEL_scorefont, score_P2)
	show_score_P2:setPosition(300,65)
	self:addChild(show_score_P2)
end
function P1_LEVEL2:score()
	local switch = {
		[0] = function()    -- for case 0
			RoundText = "對方的回合"
			Redboard:setPosition(250,-55)
			Grayboard:setPosition(18,-55)
			self:addChildAt(Redboard,2)
			self:addChildAt(Grayboard,2)
		end,
		[1] = function()    -- for case 1
			RoundText = "我方的回合"
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
function P1_LEVEL2:onEnterFrame()
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

function P1_LEVEL2:onTransitionInBegin()
	print("P1_LEVEL2 - enter begin")
end

function P1_LEVEL2:onTransitionInEnd()
	print("P1_LEVEL2 - enter end")
end

function P1_LEVEL2:onTransitionOutBegin()
	print("P1_LEVEL2 - exit begin")
end

function P1_LEVEL2:onTransitionOutEnd()
	print("P1_LEVEL2 - exit end")
end
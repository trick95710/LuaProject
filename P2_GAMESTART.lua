require "Config"
require "box2d"
require "AddFunction"
P2_GAMESTART = Core.class(Sprite)

User = "P2"

function P2_GAMESTART:init()


----------- UDP

	socket = require("socket")
	
	function sendballPosition2()
		if theUdp then
			theUdp:sendto(ball2:getX().."/"..ball2:getY(),sendToIP, 9001)
		end
	end
	
	function Post_Round_P2()
		if theUdp2 then
			theUdp2:sendto("P1",sendToIP,8001)
		end
	end
	
	function Post_draw_start_P2()
		if theUdp3 then
			theUdp3:sendto("DrawStop",sendToIP,7001)
		end
	end
	-- Post Score at 6001
	function P2_Post_Score()
		if theUdp4 then
			theUdp4:sendto(score_P2,sendToIP,6001)
		end
	end
	
-- Set variable------------------------
-- set draw == 1 start to draw band_l && band_r
-- draw == 0 will stop  to draw
	drawNum = "DrawStart"
	-- Count touch ground
	CountGround = 1
	-- set Boxes Score
	BoxScore = 0
	-- set random  seed
	math.randomseed(os.time())
	-- set RulesBox
	local result = {"blue" , "purple" , "red" , "green" , "pink" , "white"}
	-- set RulesRound
	local hitRound = ""
	-- random result
	shuffle(result)
	getarray = ""
	for i = 1 , #result do
		if i == 1 then
			getarray = result[i]
		else
			getarray = getarray .."/".. result[i]
		end
	end
	print(getarray)
	JudgeHitBox = getarray:split()
	print(JudgeHitBox[5])
	-- random hitRound
	for i = 1 , 10 do
		randomNum = math.random(50)
		randomNum = randomNum % 3 + 1
		if i == 1 then
			hitRound = randomNum
		else
			hitRound = hitRound .. "/" .. randomNum
		end
	end
	print(hitRound)
	
----------------------------------------
----------- SendballPosition timer
	postballposition_P2 = Timer.new(10)
	postballposition_P2:addEventListener(Event.TIMER, function()
		sendballPosition2()
		--print(ball:getPosition())
	end) 
----------- TIMER ------------------------------------------------
	setballposition_P2 = Timer.new(10)
	setballposition_P2:addEventListener(Event.TIMER, function()
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
	setballposition_P2:start()
	
	local ReduceDelay = false
	
	setRound_P2 = Timer.new(10)
	setRound_P2:addEventListener(Event.TIMER, function()
		repeat
			if theUdp2 then
				local ip2, port2
				local reNew2 = true
					getRound , ip2 , port2 = theUdp2:receivefrom()
					if getRound then
						if reNew2 then
							Round = getRound			
							reNew2 = false
						else
							
						end
					end		
			end
			if Round == "P1" then
					postballposition_P2:stop()
					Get_score_P1_Timer:start()
					setballposition_P2:start()
					ReduceDelay = true
			end
			if Round == "P2" then
				if ReduceDelay then
					self:score()
					ReduceDelay = false 
				end
				Timer.delayedCall(400, function()
					Get_score_P1_Timer:stop()
					setballposition_P2:stop()
					postballposition_P2:start()
					
				end)
			
			end
		until not getRound
	end)
	setRound_P2:start()
	
	drawtimer = Timer.new(10)
	drawtimer:addEventListener(Event.TIMER, function()
		repeat 
			if theUdp3 then
				local ip3, port3
				local reNew3 = true
					getdraw , ip3 , port3 = theUdp3:receivefrom()
					if getdraw then
						if reNew3 then
							drawNum = getdraw
							self.band_l:clear()
							self.band_r:clear()
						else
							
						end
					end
			end
		until not getdraw
		if debugRound == false then
			if drawNum == "DrawStart" then
				P2_draw()
			end
		end
	end)
	drawtimer:start()
	
	Ball2isAwake_Timer = Timer.new(10)
	Ball2isAwake_Timer:addEventListener(Event.TIMER,function()
		-- judge if ball exist
		if ball2_body and ball2.destroyBody == false then
			-- judge if ball is sleep
			if ball2_body:isAwake() == false then
				print("Ball is sleep")
				-- reset ball
				P2_resetBall()
			end
			SpeedX , SpeedY = ball2_body:getLinearVelocity()
			if tostring(SpeedY) == "-4.7710671054872e-021" then
				P2_resetBall()
			end
		else
			-- ball not exist
			Ball2isAwake_Timer:stop()
		end
	end)
	
	Get_score_P1_Timer = Timer.new(10)
	Get_score_P1_Timer:addEventListener(Event.TIMER,function()
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
	if debugDraw then
		local debugDraw = b2.DebugDraw.new()
		self.world:setDebugDraw(debugDraw)
		self:addChild(debugDraw)
	end
	Boundary = Boundary.new(self)


---------------function-----------------------------------------------
	function P2_draw()
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
	function P2_resetBall()
		
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
		P2_Post_Score()
		-- Post Round
		Post_Round_P2()
		
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
		P2_draw()
		
		Timer.delayedCall(200, function()
			-- set P1 Round
			Round ="P1"
			-- turn Round
			self:score()
			drawNum = "DrawStart"
		end)
		
		-- reset variable--------
		CountGround = 1 
		BoxScore = 0
		-------------------------
		
		CountRound = CountRound + 1
		self:setRound()
		print("P2_GAMESTART CountRound: " .. CountRound)
	end
----------- 畫面佈局：
	-- create background
	local bg = Bitmap.new(Texture.new("picture/bg3.png"))
	
	
	RoundBox = Bitmap.new(Texture.new("picture/RoundBox.png"))
	RoundBox:setPosition(190,0)
	RoundBox:setScale(.1,.1)
	
	RoundBoxText = TextField.new(scorefont, CountRound)
	RoundBoxText:setAnchorPoint(.5,.5)
	RoundBoxText:setPosition(220,46)
	self:addChild(RoundBoxText)
	
	
	-- show score
	score_P1 = 0
	score_P2 = 0
	
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
	show_P1_word = TextField.new(scorefont, "P1 Score :")
	show_P1_word:setTextColor(0x000000)
	show_P1_word:setPosition(50,45)
	self:addChild(show_P1_word)
	
	-- show P1 score on stage
	show_score_P1 = TextField.new(scorefont, score_P1)
	show_score_P1:setTextColor(0x000000)
	show_score_P1:setPosition(70,65)
	self:addChild(show_score_P1)
	
	
	-- show P2 Score
	show_P2_word = TextField.new(scorefont, "P2 Score :")
	show_P2_word:setTextColor(0x000000)
	show_P2_word:setPosition(280,45)
	self:addChild(show_P2_word)
	
	-- show P2 score on stage
	show_score_P2 = TextField.new(scorefont, score_P2)
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
	
	Boxes = Boxes.new(self)
    

	self:addChildAt(bg,1)
	self:addChildAt(Redboard,2)
	self:addChildAt(Grayboard,2)
	self:addChildAt(self.slingshot_r2,2)
	self:addChildAt(RoundBox,2)
	self:addChildAt(self.band_r, 3)
	self:addChildAt(ball2,4)
	self:addChildAt(self.band_l, 5)
	self:addChildAt(self.slingshot_l2,6)
	
	
	
	
--------------------------------------------------------------------------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	ball2:addEventListener(Event.MOUSE_DOWN, onMouseDown, self)
	ball2:addEventListener(Event.MOUSE_MOVE, onMouseMove, self)
	ball2:addEventListener(Event.MOUSE_UP, onMouseUp, self)
	
	self.world:addEventListener(Event.BEGIN_CONTACT, P2_onBeginContact)
	
-- Get in or out to enter down of all the function
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function P2_onBeginContact(event)
	-- you can get the fixtures and bodies in this contact like:
	local fixtureA = event.fixtureA
	local fixtureB = event.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	
	if ball2.destroyBody == false then
		if bodyB.name == "ball2" then
			P2_box2d(bodyA.name)
			if  bodyA.name == "ground" then
				CountGround = CountGround + 1
			end
		end
		print("begin contact: "..bodyA.name.."<->"..bodyB.name)
	end
end

function onMouseDown(self , event)
	print(Round)
	if Round == "P2" or debugRound then
		local bird = ball2
		if bird:hitTestPoint(event.x, event.y) and bird.isFly ~= true then
			bird.isFocus = true
			
			bird.x0, bird.y0 = event.x, event.y
			
			postballposition_P2:start()
			
			event:stopPropagation()
		end
	end
end

function onMouseMove(self , event)
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
		
		
		P2_draw()
		
		event:stopPropagation()
	end
end

function onMouseUp(self , event)
	if ball2.isFocus and ball2.isFly ~= true then
	
		ball2.isFocus = false
		
		Post_draw_start_P2()
		
		ball2_body = self.world:createBody{type = b2.DYNAMIC_BODY}
		circle_shape = b2.CircleShape.new(0, 0, ball2:getWidth() / 2-3.5)
		ball2_fixture = ball2_body:createFixture{shape = circle_shape, density = 1.0, friction = .5, restitution = 0}
			
		ball2.body = ball2_body
		ball2.body:setPosition(ball2:getX() , ball2:getY() )
		
		ball2.body:applyForce((self.start_x - ball2:getX()) * 22, (self.start_y - ball2:getY()) * 20, ball2.body:getWorldCenter())
		ball2_body.name = "ball2"
		ball2.isFly = true
		ball2.destroyBody = false
		self.band_l:clear()
		self.band_r:clear()
		
		
		Ball2isAwake_Timer:start()
		
		event:stopPropagation()
	end
end

function P2_box2d(decidebox)
	-- Blue > Purple > red > green > pink > white
	local box2d_switch = {
		["bluebox"] = function()
			BoxScore = blueboxScore
		end,
		["purplebox"] = function()
			BoxScore = purpleboxScore
		end,
		["redbox"] = function()
			BoxScore = redboxScore
		end,
		["greenbox"] = function()
			BoxScore = greenboxScore
		end,
		["pinkbox"] = function()
			BoxScore = pinkboxScore
		end,
		["whitebox"] = function()
			BoxScore = whiteboxScore
		end
	}
	
	local judge = box2d_switch[decidebox]
	if(judge) then
		judge()
		P2_resetBall()
	else
		--
	end
end
function P2_GAMESTART:setRound()
	if CountRound < GameEndRound then
		self:removeChild(RoundBoxText)
		
		RoundBoxText = TextField.new(scorefont, CountRound)
		
		RoundBoxText:setAnchorPoint(.5,.5)
		RoundBoxText:setPosition(220,46)
		self:addChild(RoundBoxText)
	end
	if CountRound == GameEndRound then
		sceneManager:changeScene("GameEnd", 1, SceneManager.fade, easing.linear)
	elseif CountRound >= 11 then
		
	elseif CountRound >= 6 then
		self:SixRound()
		if setBox then
		-- World is locked have delayTime
			Timer.delayedCall(.5, function()
				firstBaffle = BaffleBox.new(self,200,200,"box",.5,1)
				firstBaffle2 = BaffleBox.new(self,250,200,"box2",.5,1)
				setBox = false
			end)
		end
	end
end
function P2_GAMESTART:JudgeHitBall()
	local HitBall_switch = {
		["blue"] = function()
			HitBallImg = "picture/JudgeBall/blue.png"
			blueboxScore = -blueboxScore
		end,
		["purple"] = function()
			HitBallImg = "picture/JudgeBall/purple.png"
			purpleboxScore = -purpleboxScore
		end,
		["red"] = function()
			HitBallImg = "picture/JudgeBall/red.png"
			redboxScore = -redboxScore
		end,
		["green"] = function()
			HitBallImg = "picture/JudgeBall/green.png"
			greenboxScore = -greenboxScore
		end,
		["pink"] = function()
			HitBallImg = "picture/JudgeBall/pink.png"
			pinkboxScore = -pinkboxScore
		end,
		["white"] = function()
			HitBallImg = "picture/JudgeBall/white.png"
			whiteboxScore = -whiteboxScore
		end
	}
	
	local judge_ball = HitBall_switch[JudgeHitBox[CountRound-5]]
	
	if(judge_ball) then
		judge_ball()
	else
		--
	end
end
function P2_GAMESTART:SixRound()
	blueboxScore = neblueboxScore
	purpleboxScore = nepurpleboxScore
	redboxScore = neredboxScore
	greenboxScore = negreenboxScore
	pinkboxScore = nepinkboxScore
	whiteboxScore = newhiteboxScore
	
	if debugRound then
		if CountRound ~= 6 then
			self:removeChild(HitBallPicture)
		end
		self:JudgeHitBall()
		
		HitBallPicture = Bitmap.new(Texture.new(HitBallImg),true)
		HitBallPicture:setAnchorPoint(.5,.5)
		HitBallPicture:setScale(.35,.35)
		HitBallPicture:setPosition(screen_height/2-40,75)
		self:addChild(HitBallPicture)
	end
end

function P2_GAMESTART:resetScore()
	-- reset Score
	self:removeChild(show_score_P2)
	-- calc score_P2
	score_P2 = score_P2 + (CountGround * BoxScore)
	-- reset score_P2
	show_score_P2 = TextField.new(scorefont, score_P2)
	show_score_P2:setPosition(300,65)
	show_score_P2:setTextColor(0x000000)
	-- show
	self:addChild(show_score_P2)
end


function P2_GAMESTART:SetP1Score()
	self:removeChild(show_score_P1)
	show_score_P1 = TextField.new(scorefont, score_P1)
	show_score_P1:setPosition(70,65)
	self:addChild(show_score_P1)
end



function P2_GAMESTART:score()
	local switch = {
		["P2"] = function()    -- for case 0
			RoundText = "我方的回合"
			Redboard:setPosition(250,-55)
			Grayboard:setPosition(18,-55)
			self:addChildAt(Redboard,2)
			self:addChildAt(Grayboard,2)
		end,
		["P1"] = function()    -- for case 1
			RoundText = "對方的回合"
			Redboard:setPosition(18,-55)
			Grayboard:setPosition(250,-55)
			self:addChildAt(Redboard,2)
			self:addChildAt(Grayboard,2)
		end			
	}
	local Record = Round
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


function P2_GAMESTART:onEnterFrame()
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
function P2_GAMESTART:onTransitionInBegin()
	print("P2_GAMESTART - enter begin")
end

function P2_GAMESTART:onTransitionInEnd()
	print("P2_GAMESTART - enter end")
end

function P2_GAMESTART:onTransitionOutBegin()
	print("P2_GAMESTART - exit begin")
end

function P2_GAMESTART:onTransitionOutEnd()
	print("P2_GAMESTART - exit end")
end
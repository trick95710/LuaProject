--require "Config"


P1_GAMESTART = Core.class(Sprite)



function P1_GAMESTART:init()
	User = "P1"
----------- UDP
	socket = require("socket")
----------- Send
	
	-- Post ball position at port 9001
	function sendballPosition()
		if theUdp then
			theUdp:sendto(ball:getX().."/"..ball:getY(),sendToIP, 9001)
		end
	end

	-- Post Round at 8001 , that can turn player 
	function Post_Round()
		if theUdp2 then
			theUdp2:sendto("P2",sendToIP,8001)
		end
	end

	-- Post start draw at 7001 
	function Post_draw_start()
		if theUdp3 then
			theUdp3:sendto("DrawStop",sendToIP,7001)
		end
	end
	-- Post Score at 6001
	function P1_Post_Score()
		if theUdp4 then
			theUdp4:sendto(score_P1,sendToIP,6001)
		end
	end
-- Set variable----------------------	--
	-- set draw == 1 start to draw band_l && band_r
	-- draw == 0 will stop  to draw
	drawNum = "DrawStop"
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
	for i = 1 , #result-1 do
		if i == 1 then
			getarray = result[i]
		else
			getarray = getarray .."/".. result[i]
		end
	end
	
	JudgeHitBox = getarray:split()
	-- random hitRound
	for i = 1 , 5 do
		randomNum = math.random(50)
		randomNum = randomNum % 3 + 1
		if i == 1 then
			hitRound = randomNum
		else
			hitRound = hitRound .. "/" .. randomNum
		end
	end
	
	for i = 1 ,7 do
		boxrandom = math.random(0+45,320-45)
		if i == 1 then
			setYbox = boxrandom
		else
			setYbox = setYbox .. "/" .. boxrandom
		end
	end
	
	firstRemove = true
	
	function PostRandomArray()
		if theUdp5 then
			theUdp5:sendto(getarray.."/"..hitRound.."/"..setYbox,sendToIP,5001)
		end
	end
	
	print(getarray.."/"..hitRound.."/"..setYbox)
	
	RandomSet = setYbox:split()
	for i = 1 , #RandomSet do
		print(RandomSet[i])
	end
	
----------------------------------------
----------- SendballPosition timer
	postballposition = Timer.new(10)
	postballposition:addEventListener(Event.TIMER, function()
		sendballPosition()
		--print(ball:getPosition())
	end) 
----------- Timer ------------------------------------------------------------

	setballposition = Timer.new(10)
	setballposition:addEventListener(Event.TIMER, function()
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
	--setballposition:start()
	
	local ReduceDelay = false
	
	setRound = Timer.new(10)
	setRound:addEventListener(Event.TIMER, function()
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
			-- Round == "P2" for P2 
			-- P1 will stop post Ball and start get Ball
			if Round == "P2" then
				postballposition:stop()
				Get_score_P2_Timer:start()
				setballposition:start()
				--reset For P2 turn P1 to do  
				-- if Round == "P1" && ReduceDelay == 1 
				ReduceDelay = true
			end
			-- Round == 1 for P1
			-- P1 will stop get Ball and start post Ball
			if Round == "P1" then
				if ReduceDelay or debugRound then
					-- turn Round
					self:score()
					
					self:setRoundRules()
					-- just in for once time
					ReduceDelay = false
				end
				-- have to delay to stop set ball
				-- that will be reset ball position
				Timer.delayedCall(500, function()
					Get_score_P2_Timer:stop()
					setballposition:stop()
					postballposition:start()
				end)		
			end
		until not getRound
	end)
	setRound:start()
	
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
							-- get getdraw will clean band_l && band_r
							self.band_l:clear()
							self.band_r:clear()
						else
							
						end
					end
			end
		until not getdraw
		
		-- if get drawNum == 1 to draw band_l && band_r
		if debugRound == false then
			if drawNum == "DrawStart" then
				draw()
			end
		end
	end)
	drawtimer:start()
	
	BallisAwake_Timer = Timer.new(10)
	BallisAwake_Timer:addEventListener(Event.TIMER,function()
		-- judge if ball exist
		
		if ball_body and ball.destroyBody == false then
			-- judge if ball is sleep
			if ball_body:isAwake() == false then
				print("Ball is sleep")
				-- reset ball
				resetBall()
			end
			SpeedX , SpeedY = ball_body:getLinearVelocity()
			print(SpeedY)
			if tostring(SpeedY) == "-4.7710671054872e-021" then
				resetBall()
			end
		else
			-- ball not exist
			BallisAwake_Timer:stop()
		end
	end)
	
	Get_score_P2_Timer = Timer.new(10)
	Get_score_P2_Timer:addEventListener(Event.TIMER,function()
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

-------------------------------------------------------------------------

-- set world -------------------------------------------------------------
	self.world = b2.World.new(0, 10, true)
	if debugDraw then
		local debugDraw = b2.DebugDraw.new()
		self.world:setDebugDraw(debugDraw)
		self:addChild(debugDraw)
	end
	
	Boundary = Boundary.new(self)
---------------------------------------------------------------------------
---------- function -----------------------------------------------------------
	function draw()
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
	
	function resetBall()

		PostRandomArray()
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
		P1_Post_Score()
		-- Post Round
		Post_Round()
		
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
		draw()
		
		Timer.delayedCall(200, function()
			-- set P2 Round
			Round = "P2"
			-- turn Round
			self:score()
			drawNum = "DrawStart"
			
			CountRound = CountRound + 1
			if debugRound then
				self:setRoundRules()
			end
			
			print("P1_GAMESTART CountRound: " .. CountRound)
		end)
		
		-- reset variable--------
		CountGround = 1 
		BoxScore = 0		
		-------------------------
		
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
	ball = Bitmap.new(Texture.new("picture/ball.png"),true)
	-- Place ball
	ball:setScale(.065,.065,.065)
	ball:setAnchorPoint(.5,.5)
	ball:setPosition(103, screen_width-75)
	self.start_x, self.start_y = ball:getPosition()
	
	
	
	------TextureRegion.new(BlueBox,X開始,Y開始,X結束,Y結束)	
	self.slingshot_r = Bitmap.new(TextureRegion.new(spritesheet, 3, 1, 37, 199))
	self.slingshot_l = Bitmap.new(TextureRegion.new(spritesheet, 834, 1, 43, 124))
	-- Place catapult
	self.slingshot_l:setPosition(85, screen_width-94)
	self.slingshot_r:setPosition(100, screen_width-90)

	-- picture to small 0.5
	setHalf({
		self.slingshot_r,
		self.slingshot_l
	})
	
	
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
	Boxes = Boxes.new(self)
	
	----------------------------------------------------------------------------------------------------
	
	-- Add All of sprite to scene
	self:addChildAt(bg,1)
	self:addChildAt(Redboard,2)
	self:addChildAt(Grayboard,2)
	self:addChildAt(RoundBox,2)
	self:addChildAt(self.slingshot_r, 2)
	self:addChildAt(self.band_r, 3)
	self:addChildAt(ball, 4)
	self:addChildAt(self.band_l, 5)
	self:addChildAt(self.slingshot_l, 6)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	ball:addEventListener(Event.MOUSE_DOWN, onMouseClickDown, self)
	ball:addEventListener(Event.MOUSE_MOVE, onMouseClickMove, self)
	ball:addEventListener(Event.MOUSE_UP, onMouseClickUp, self)
	
	self.world:addEventListener(Event.BEGIN_CONTACT, P1_onBeginContact)
	
-- Get in or out to enter down of all the function
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function P1_onBeginContact(event)
	-- you can get the fixtures and bodies in this contact like:
	local fixtureA = event.fixtureA
	local fixtureB = event.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	
	if ball.destroyBody == false then
		if bodyB.name == "ball" then
			box2d(bodyA.name)
			if  bodyA.name == "ground" then
				CountGround = CountGround + 1
			end
		end
		print("begin contact: "..bodyA.name.."<->"..bodyB.name)
	end
end

-- this function to small the picture
-- use the array to call in this function

function onMouseClickDown(self, event)
	print(Round)
	if Round == "P1" or debugRound then
		
		local bird = ball
		if bird:hitTestPoint(event.x, event.y) and bird.isFly ~= true then
			bird.isFocus = true
			
			bird.x0, bird.y0 = event.x, event.y
			
			
			postballposition:start()
			event:stopPropagation()
		end
	end
end

function onMouseClickMove(self, event)
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
		
		draw()
		
		event:stopPropagation()
	end
end

function onMouseClickUp(self, event)
	if ball.isFocus and ball.isFly ~= true then
		
		ball.isFocus = false
		
		-- stop to draw
		Post_draw_start()
		
		ball_body = self.world:createBody{type = b2.DYNAMIC_BODY}
		circle_shape = b2.CircleShape.new(0, 0, ball:getWidth() / 2-3.5)
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
		
		BallisAwake_Timer:start()
		
		event:stopPropagation()
	end
end
function box2d(decidebox)
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
		resetBall()
	else
		--
	end
end
function P1_GAMESTART:setRoundRules()
	if CountRound < GameEndRound and Round == "P1" then
		self:removeChild(RoundBoxText)
		
		RoundBoxText = TextField.new(scorefont, CountRound)
		RoundBoxText:setAnchorPoint(.5,.5)
		RoundBoxText:setPosition(220,46)
		self:addChild(RoundBoxText)
	end
	if CountRound == GameEndRound then
		sceneManager:changeScene("GameEnd", 1, SceneManager.fade, easing.linear)
	elseif CountRound >= 11 then
		if CountRound == 11 and firstRemove then
			self:removeChild(HitBallPicture)
			firstRemove = false
		end
		print("123")
		blueboxScore = math.abs(blueboxScore)
		purpleboxScore = math.abs(purpleboxScore)
		redboxScore = math.abs(redboxScore)
		greenboxScore = math.abs(greenboxScore)
		pinkboxScore = math.abs(pinkboxScore)
		whiteboxScore = math.abs(whiteboxScore)
		if Round == "P1" or debugRound then
			if CountRound == 11 then
				Baffle = BaffleBox.new(self,280,RandomSet[3],"box3",.2,.5)
			end
			if CountRound == 12 then
				Baffle = BaffleBox.new(self,300,RandomSet[4],"box4",.2,.5)
			end
			if CountRound == 13 then
				Baffle = BaffleBox.new(self,320,RandomSet[5],"box5",.2,.5)
			end
			if CountRound == 14 then
				Baffle = BaffleBox.new(self,330,RandomSet[6],"box6",.2,.5)
			end
			if CountRound == 15 then
				Baffle = BaffleBox.new(self,350,RandomSet[7],"box7",.2,.5)
			end
		end
	elseif CountRound >= 6 then
		print("in")
		self:SixRound()
		if setBox then
		-- World is locked have delayTime
			Timer.delayedCall(.5, function()
				Baffle = BaffleBox.new(self,220,RandomSet[1]+50,"box",.5,1)
				Baffle = BaffleBox.new(self,380,RandomSet[2],"box2",.5,1)
				setBox = false
			end)
		end
	end
end
function P1_GAMESTART:JudgeHitBall()
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
	print(Round)
	
	local judge_ball = HitBall_switch[JudgeHitBox[CountRound-5]]
	
	
	if(judge_ball) then
		judge_ball()
	else
		--
	end
end
function P1_GAMESTART:SixRound()
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
		HitBallPicture:setScale(.2,.2)
		HitBallPicture:setPosition(screen_height/2-40,75)
		self:addChild(HitBallPicture)
	else
		if Round == "P1" then
			if CountRound ~= 6 then
				self:removeChild(HitBallPicture)
			end
			self:JudgeHitBall()
			
			HitBallPicture = Bitmap.new(Texture.new(HitBallImg),true)
			HitBallPicture:setAnchorPoint(.5,.5)
			HitBallPicture:setScale(.2,.2)
			HitBallPicture:setPosition(screen_height/2-40,75)
			self:addChild(HitBallPicture)
		end
	end
end

function P1_GAMESTART:resetScore()
	-- reset Score
	self:removeChild(show_score_P1)
	-- calc score_P1
	score_P1 = score_P1 + (CountGround * BoxScore)
	-- reset score_P1
	show_score_P1 = TextField.new(scorefont, score_P1)
	show_score_P1:setPosition(70,65)
	show_score_P1:setTextColor(0x000000)
	-- show
	self:addChild(show_score_P1)
end
function P1_GAMESTART:SetP2Score()
	self:removeChild(show_score_P2)
	show_score_P2 = TextField.new(scorefont, score_P2)
	show_score_P2:setPosition(300,65)
	self:addChild(show_score_P2)
end
function P1_GAMESTART:score()
	local switch = {
		["P2"] = function()    -- for case 0
			RoundText = "對方的回合"
			Redboard:setPosition(250,-55)
			Grayboard:setPosition(18,-55)
			self:addChildAt(Redboard,2)
			self:addChildAt(Grayboard,2)
		end,
		["P1"] = function()    -- for case 1
			RoundText = "我方的回合"
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
function P1_GAMESTART:onEnterFrame()
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



function P1_GAMESTART:onTransitionInBegin()
	print("P1_GAMESTART - enter begin")
end

function P1_GAMESTART:onTransitionInEnd()
	print("P1_GAMESTART - enter end")
end

function P1_GAMESTART:onTransitionOutBegin()
	print("P1_GAMESTART - exit begin")
end

function P1_GAMESTART:onTransitionOutEnd()
	print("P1_GAMESTART - exit end")
end
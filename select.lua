select = Core.class(Sprite)

function select:init()
	
	socket = require("socket")
	
	
	
	local EnterBtn = nil
	local P1_PlayerBtn = "NotReady"
	local P2_PlayerBtn = "NotReady"

	

	local function sendBtnData()	
		if theUdp then --送1筆資料過去
			-- EnterBtn = 1 P1_Btn is click
			if EnterBtn == "P1" then
				theUdp:sendto(P1_PlayerBtn, sendToIP, 9001)
				print(sendToIP)
				print(P1_PlayerBtn)
			-- EnterBtn = 2 P2_Btn is click
			elseif EnterBtn == "P2" then
				theUdp:sendto(P2_PlayerBtn, sendToIP, 9001)
				print(P2_PlayerBtn)
			end
			
		end
	end
-----------------------
---主程式--- 
	
	
-- connect player of ip
	local SelectTimer = Timer.new(10)
	SelectTimer:addEventListener(Event.TIMER, function()
		repeat
			if theUdp then
				local ip, port
				local reNew = true
				
				--try to get any data (可接收多筆資料)
				-- ip 是 自己的
				GetBtn, ip, port = theUdp:receivefrom() --接收傳來的資料
				if GetBtn then
					if reNew then
						print("GetBtn = "..GetBtn)
						SelectBtn = GetBtn
						reNew = false
					end
				end
			end
			-- if others player select P1
			-- you will P2
			if SelectBtn == "P1_IsReady" then
				if P2_PlayerBtn == "P2_IsReady" then
					sceneManager:changeScene("P2_GAMESTART", 1, SceneManager.fade, easing.linear) 
					print("關閉 select of SelectTimer")
					SelectTimer:stop()
				end
			end
			--if others player select P2
			-- you will P1
			if SelectBtn == "P2_IsReady" then
				if P1_PlayerBtn == "P1_IsReady" then
					
					sceneManager:changeScene("P1_GAMESTART", 1, SceneManager.fade, easing.linear)
					print("關閉 select of SelectTimer")
					SelectTimer:stop()
				end	
			end
		until not GetBtn
	end)
	
	SelectTimer:start()
	
----------- 畫面佈局：
	local bg = Bitmap.new(Texture.new("picture/bg4.jpg"))
	self:addChildAt(bg,1)

	font = TTFont.new("font/setofont.ttf", 20, true)
	local ShowText = TextField.new(font, "請選擇 P1 或 P2")
	ShowText:setPosition(160,100)
	self:addChild(ShowText)
	
	local P1_Btn_close = Button.new(imgDown, imgDown, "P1")
	P1_Btn_close:setPosition(center_height-75,center_width)
	
	
	BackBtn = BackStart.new(self)
	
	-- go to P1_GAMESTART scene
	local P1_Btn = Button.new(imgUp, imgDown, "P1")
	P1_Btn:setPosition(center_height-75,center_width)
	
	P1_Btn:addEventListener("click" , function()
		if EnterBtn == nil then
			P1_PlayerBtn = "P1_IsReady"
			-- confirm Btn click
			EnterBtn = "P1"
			sendBtnData()
			self:removeChild(P1_Btn)
			self:addChild(P1_Btn_close)
		end
		--------------------
	end)
	
	P1_Btn_close:addEventListener("click" , function()
		if EnterBtn then
			P1_PlayerBtn = "P1_NotReady"
			-- confirm Btn click
			sendBtnData()
			EnterBtn = nil
			self:removeChild(P1_Btn_close)
			self:addChild(P1_Btn)
		end
		--------------------
	end)
	
	self:addChild(P1_Btn)
	
	
	local P2_Btn_close = Button.new(imgDown, imgDown, "P2")
	P2_Btn_close:setPosition(center_height+75,center_width)
	
	
	
	-- go to P2_GAMESTART scene
	local P2_Btn = Button.new(imgUp, imgDown, "P2")
	P2_Btn:setPosition(center_height+75,center_width)
	
	P2_Btn:addEventListener("click" , function()
		if EnterBtn == nil then
			P2_PlayerBtn = "P2_IsReady"
			-- confirm Btn click
			EnterBtn = "P2"
			sendBtnData()
			self:removeChild(P2_Btn)
			self:addChild(P2_Btn_close)
		end
		--------------------		
	end)
	
	P2_Btn_close:addEventListener("click" , function()
		if EnterBtn then
			P2_PlayerBtn = "P2_NotReady"
			-- confirm Btn click
			sendBtnData()
			EnterBtn = nil
		end
		---------------------
		self:removeChild(P2_Btn_close)
		self:addChild(P2_Btn)
	end)
	
	self:addChild(P2_Btn)
	
-- Get in or out to enter down of all the function
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function select:onTransitionInBegin()
	print("select - enter begin")
end

function select:onTransitionInEnd()
	print("select - enter end")
end

function select:onTransitionOutBegin()
	print("select - exit begin")
end
 
function select:onTransitionOutEnd()
	print("select - exit end")
end
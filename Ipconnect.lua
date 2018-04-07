Ipconnect = gideros.class(Sprite)

function Ipconnect:init()
	
	
	-- create background
	local bg = Bitmap.new(Texture.new("picture/IpconnectPicture.png"))
	self:addChildAt(bg,1)
	
	socket = require("socket")

	font = TTFont.new("font/setofont.ttf", 20, true)
	theUdp = nil
	
	sendToIP = "xxx.xxx.xxx.xxx"
	
	local Btn_Ready = "NotReady"
	
	--取得本身IP
	local function getMyIP()
		local s = socket.udp()
		s:setpeername("88.88.88.88",80)
		local ip, _ = s:getsockname()
		return ip
	end
	
	--取得Send_To (對方) IP
	local function getSendToIP()
		return sendToIP
	end
	
	-- send message to the other side (傳送Data給對方)
	local function sendData()	
		if theUdp then --送1筆資料過去
			theUdp:sendto(Btn_Ready, sendToIP, 9001)
		end
	end

	
-----------------------
	---主程式---
	--建立UDP socket 並bind到 9001 port 
	theUdp = socket.udp()
	theUdp:setsockname(getMyIP(), 9001)
	theUdp:settimeout(0)
	
	
	---主程式---
	--建立UDP2 socket 並bind到 8001 port 
	theUdp2 = socket.udp()
	theUdp2:setsockname(getMyIP(),8001)
	theUdp2:settimeout(0)
	
	
	---主程式---
	--建立UDP3 socket 並bind到 7001 port 
	theUdp3 = socket.udp()
	theUdp3:setsockname(getMyIP(),7001)
	theUdp3:settimeout(0)
	
	---主程式---
	--建立UDP4 socket 並bind到 6001 port 
	theUdp4 = socket.udp()
	theUdp4:setsockname(getMyIP(),6001)
	theUdp4:settimeout(0)
	
	---主程式---
	--建立UDP5 socket 並bind到 5001 port 
	theUdp5 = socket.udp()
	theUdp5:setsockname(getMyIP(),5001)
	theUdp5:settimeout(0)
	
	--建立計時器Timer
	local IpTimer = Timer.new(10)
	--call on each timer tick (每100ms發作一次)
	IpTimer:addEventListener(Event.TIMER, function()
		--to ensure responsiveness of our application
		--we should better loop through all available information at one timer call
		repeat
			if theUdp then
				local ip, port
				local reNew = true
				--try to get any data (可接收多筆資料)
				-- ip 是 自己的
				IfReady, ip, port = theUdp:receivefrom() --接收傳來的資料
				if IfReady then
					if reNew then
						GetReady = IfReady					
						--msgTxt:setText(recvMsg) --顯示於畫面(蓋掉舊資料) 
						reNew = false
					end
				end
				
				
			end
			
			if Btn_Ready == "IsReady" and GetReady == "IsReady" then
				
				sceneManager:changeScene("select", 1, SceneManager.fade, easing.linear) 
				print("停止IpTimer")
				IpTimer:stop()
				
			end
		until not IfReady
	end)
	--start the IpTimer
	IpTimer:start()
	
	
----------- 畫面佈局：
	
-- back of Btn
	--[[
	local backUp = Button.new(imgUp, imgDown, "返回")
	backUp:setPosition(45,screen_width-12.5)
	backUp:addEventListener("click", function()
		Btn_Ready = "NotReady"
		IpTimer:stop()
		sceneManager:changeScene("start", 1, SceneManager.fade, easing.linear) 
	end)	
	self:addChild(backUp)
	]]
	
	BackBtnIp = BackStart.new(self)

-- Show my IP
	local myIpTxt = TextField.new(font, "我的IP: "..getMyIP())
	myIpTxt:setPosition(center_height-100,center_width-100)
	self:addChild(myIpTxt)
	
-- Show Send_to IP
	local sendToIpTxt = TextField.new(font, "對方玩家IP: "..sendToIP)
	sendToIpTxt:setPosition(center_height-100,center_width-50)
	self:addChild(sendToIpTxt)
	
--Ready of Btn

	local READY = Button.new(imgUp, imgDown, "準備")
	READY:setPosition(center_height,center_width)
	READY:addEventListener("click", function()
		Btn_Ready = "IsReady"
		sendData()
		
		self:removeChild(READY)
		local cancelready = Button.new(imgDown, imgDown, "取消準備")
		cancelready:setPosition(center_height,center_width)
		cancelready:addEventListener("click", function()
			Btn_Ready = "NotReady"
			sendData()
			
			self:removeChild(cancelready)
			self:addChild(READY)
		end)
		self:addChild(cancelready)
	end)
	
	-- Dialog(對話框) for setting Send_to IP (設定對方IP)
	local sendToIpDialog = TextInputDialog.new("請輸入IP", 
		"請輸入對方IP:".."\n 我的 IP :"..getMyIP(), getMyIP(), "取消", "確定")
	--"Enter the Send_to IP:", sendToIP, "Cancel", "OK")
	
	local function onSendToIpSettingOk(e) 
		if e.buttonIndex then --對話框按了OK
			sendToIP = e.text --取得user輸入的IP值
			sendToIpTxt:setText("對方玩家IP: "..sendToIP) --顯示於畫面
			
			self:removeChild(connectBtn) --移除 設定按鈕
			
			self:addChild(READY) --加入以顯示 傳送按鈕
		end
	end
	sendToIpDialog:addEventListener(Event.COMPLETE, onSendToIpSettingOk)
	
	-- Button for setting Send_to IP (設定按鈕)
	connectBtn = Button.new(imgUp,imgDown, " 輸入玩家IP",BigBtnFontSize)
	connectBtn:setScale(BigBtnScaleX,BigBtnScaleY)
	connectBtn:addEventListener("click", 
		function() 
			print("開啟輸入欄")
			sendToIpDialog:show() --啓動設定對方IP之對話框
		end)
	connectBtn:setPosition(center_height,center_width)
	self:addChild(connectBtn)
	



-- Get in or out to enter down of all the function
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function Ipconnect:onTransitionInBegin()
	print("Ipconnect - enter begin")
end

function Ipconnect:onTransitionInEnd()
	print("Ipconnect - enter end")
end

function Ipconnect:onTransitionOutBegin()
	print("Ipconnect - exit begin")
end

function Ipconnect:onTransitionOutEnd()
	print("Ipconnect - exit end")
end
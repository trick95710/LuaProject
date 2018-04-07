require "Config"

application:setScaleMode("letterbox")
application:setOrientation(Stage.LANDSCAPE_LEFT)
application:setBackgroundColor(0xFFFFFF)

--create settings instance

--Ifmusic 0 is open  
Ifmusic = 0

--background music
music = Sound.new("sound/YouTube- Whistling Down the Road.mp3")
channel = music:play(0,true)
channel:setVolume(0)


sceneManager = SceneManager.new({
	--start scene
	["start"] = start,
	--Rules scene
	["Rules"] = Rules,
	--options scene
	["options"] = options,
	--Ipconnect scene
	["Ipconnect"] = Ipconnect,
	--select scene
	["select"] = select,
	--P1_GAMESTART scene
	["P1_GAMESTART"] = P1_GAMESTART,
	--P2_GAMESTART scene
	["P2_GAMESTART"] = P2_GAMESTART,
	--GameEnd scene
	["GameEnd"] = GameEnd
})
--add manager to stage
stage:addChild(sceneManager)

--start start scene
sceneManager:changeScene("P2_GAMESTART", 1, SceneManager.fade, easing.linear)
require "Config"
require "AddFunction"
require "box2d"

application:setScaleMode("letterbox")
application:setOrientation(Stage.LANDSCAPE_LEFT)
application:setBackgroundColor(0xFFFFFF)


--background music
music = Sound.new("sound/YouTube- Whistling Down the Road.mp3")
channel = music:play(0,true)
channel:setVolume(0)

Btn_Ready = "NotReady"

sceneManager = SceneManager.new({
	--start scene
	["start"] = start,
	--Rule scene
	["Rule"] = Rule,
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
sceneManager:changeScene("start", 1, SceneManager.fade, easing.linear)
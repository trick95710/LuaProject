GameEnd = gideros.class(Sprite)

function GameEnd:init()
	
	Score_P1 = 0
	Score_P2 = 0
	
	User = "P1"
	
	
	if User == "P1" then
		if Score_P1 > Score_P2 then
			print("你贏了")
		elseif Score_P1 < Score_P2 then
			print("你輸了")
		elseif Score_P1 == Score_P2 then
			print("平手")
		end
	elseif User == "P2" then
		if Score_P2 > Score_P1 then
			print("你贏了")
		elseif Score_P2 < Score_P1 then
			print("你輸了")
		elseif Score_P2 == Score_P1 then
			print("平手")
		end
	end
	



-----------------------------------------------------------------------
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function GameEnd:onTransitionInBegin()
	print("GameEnd - enter begin")
end

function GameEnd:onTransitionInEnd()
	print("GameEnd - enter end")
end

function GameEnd:onTransitionOutBegin()
	print("GameEnd - exit begin")
end

function GameEnd:onTransitionOutEnd()
	print("GameEnd - exit end")
end
BaffleBox = Core.class(Sprite)

function BaffleBox:init(Player, x, y, name , ScaleX, ScaleY)

	if ScaleX == nil then 
		ScaleX = 1 
	end
	if ScaleY == nil then 
		ScaleY = 1 
	end	
	
	local sprite = Bitmap.new(Texture.new("picture/baffle.png"))
	sprite:setScale(ScaleX,ScaleY)
	sprite:setAnchorPoint(0.5, 0.5)
	sprite:setPosition(x,y)
	
	
	local body = Player.world:createBody{type = b2.STATIC_BODY , position = {x = x , y = y}}
	
	body.name = name
	--name.destroyBody = false
	
	local shape = b2.PolygonShape.new()
	shape:setAsBox(sprite:getWidth()/2, sprite:getHeight()/2)
	body:createFixture{shape = shape, density = 1, restitution = 0.2, friction = 0.3}

	
	
	Player:addChild(sprite)
end
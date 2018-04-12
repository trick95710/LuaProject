--require "Config"
Boxes = Core.class(Sprite)

function Boxes:init(Player)
	local BlueBox = Bitmap.new(Texture.new("picture/bluebox.png"))
	BlueBox:setScale(.2,.1924)
	BlueBox:setAnchorPoint(.5,.5)
	BlueBox:setPosition(screen_height-42.5*BlueBox:getScaleX(),277/2*BlueBox:getScaleY())
	
	local bluebox = Player.world:createBody({})
	local boundary_bluebox = b2.EdgeShape.new(BlueBox:getX(), BlueBox:getY()-138.5*BlueBox:getScaleY(), BlueBox:getX(),BlueBox:getY()+138.5*BlueBox:getScaleY())
	bluebox:createFixture({shape = boundary_bluebox, density = 0})
	bluebox.name = "bluebox"
	--
	
	--Purple
	local Purplebox = Bitmap.new(Texture.new("picture/purplebox.png"))
	Purplebox:setScale(.2,.1924)
	Purplebox:setAnchorPoint(.5,.5)
	Purplebox:setPosition(screen_height-42.5*Purplebox:getScaleX(),BlueBox:getY()+277*BlueBox:getScaleY() )
	
	local purplebox = Player.world:createBody({})
	local boundary_purplebox = b2.EdgeShape.new(Purplebox:getX(), Purplebox:getY()-138.5*Purplebox:getScaleY(), Purplebox:getX(),Purplebox:getY()+138.5*Purplebox:getScaleY())
	purplebox:createFixture({shape = boundary_purplebox, density = 0})
	
	purplebox.name = "purplebox"
	--
	--red
	local Redbox = Bitmap.new(Texture.new("picture/redbox.png"))
	Redbox:setScale(.2,.1924)
	Redbox:setAnchorPoint(.5,.5)
	Redbox:setPosition(screen_height-42.5*Redbox:getScaleX(),Purplebox:getY()+277*Purplebox:getScaleY() )
	
	local redbox = Player.world:createBody({})
	local boundary_redbox = b2.EdgeShape.new(Redbox:getX(), Redbox:getY()-138.5*Redbox:getScaleY(), Redbox:getX(),Redbox:getY()+138.5*Redbox:getScaleY())
	redbox:createFixture({shape = boundary_redbox, density = 0})
	
	redbox.name = "redbox"
	--
	--green
	local Greenbox = Bitmap.new(Texture.new("picture/greenbox.png"))
	Greenbox:setScale(.2,.1924)
	Greenbox:setAnchorPoint(.5,.5)
	Greenbox:setPosition(screen_height-42.5*Greenbox:getScaleX(),Redbox:getY()+277*Redbox:getScaleY() )
	
	local greenbox = Player.world:createBody({})
	local boundary_greenbox = b2.EdgeShape.new(Greenbox:getX(), Greenbox:getY()-138.5*Greenbox:getScaleY(), Greenbox:getX(),Greenbox:getY()+138.5*Greenbox:getScaleY())
	greenbox:createFixture({shape = boundary_greenbox, density = 0})
	
	greenbox.name = "greenbox"
	--
	--pink
	local Pinkbox = Bitmap.new(Texture.new("picture/pinkbox.png"))
	Pinkbox:setScale(.2,.1924)
	Pinkbox:setAnchorPoint(.5,.5)
	Pinkbox:setPosition(screen_height-42.5*Pinkbox:getScaleX(),Greenbox:getY()+277*Greenbox:getScaleY() )
	
	local pinkbox = Player.world:createBody({})
	local boundary_pinkbox = b2.EdgeShape.new(Pinkbox:getX(), Pinkbox:getY()-138.5*Pinkbox:getScaleY(), Pinkbox:getX(),Pinkbox:getY()+138.5*Pinkbox:getScaleY())
	pinkbox:createFixture({shape = boundary_pinkbox, density = 0})
	
	pinkbox.name = "pinkbox"
	--
	--white
	local Whitebox = Bitmap.new(Texture.new("picture/whitebox.png"))
	Whitebox:setScale(.2,.1924)
	Whitebox:setAnchorPoint(.5,.5)
	Whitebox:setPosition(screen_height-42.5*Whitebox:getScaleX(),Pinkbox:getY()+277*Pinkbox:getScaleY())
	
	local whitebox = Player.world:createBody({})
	local boundary_whitebox = b2.EdgeShape.new(Whitebox:getX(), Whitebox:getY()-138.5*Whitebox:getScaleY(), Whitebox:getX(),Whitebox:getY()+138.5*Whitebox:getScaleY())
	whitebox:createFixture({shape = boundary_whitebox, density = 0})
	
	whitebox.name = "whitebox"
	
	Player:addChildAt(BlueBox, 3)
	Player:addChildAt(Purplebox, 3)
	Player:addChildAt(Redbox, 3)
	Player:addChildAt(Greenbox, 3)
	Player:addChildAt(Pinkbox, 3)
	Player:addChildAt(Whitebox, 3)

end
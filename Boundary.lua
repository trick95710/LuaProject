--require "box2d"
Boundary = Core.class(Sprite)

function Boundary:init(Player)
	local Boundary_down = b2.EdgeShape.new(0, screen_width, screen_height, screen_width)
	local Boundary_left = b2.EdgeShape.new(0, 0, 0, screen_width)
	local Boundary_right = b2.EdgeShape.new(0, 0, screen_height, 0)
	--local Boundary_up = b2.EdgeShape.new(screen_height, 0, screen_height, screen_width)
	
	local ground = Player.world:createBody({})
	ground:createFixture({shape = Boundary_left, density = 0.5,restitution = 0.6})
	ground:createFixture({shape = Boundary_right, density = 0.5,restitution = 0.3})
	--ground:createFixture({shape = Boundary_up, density = 0})
	ground:createFixture({shape = Boundary_down, density = 0.5,restitution = 0.8})
	ground.name = "ground"
end
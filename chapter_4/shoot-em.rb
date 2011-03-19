require 'engine'
require 'plane'

include Rubygame

def main
	engine = Engine.new
	engine.screen_width = 1024
	engine.screen_height = 768
	
	engine.screen
	
	src = Rect.new(499,4,98,98)
	player = PlayerPlane.new("1945.bmp",src)
	player.colorkey = [0, 67,171]
	engine.components << player

	engine.run
end

if __FILE__ == $0
	main()
end

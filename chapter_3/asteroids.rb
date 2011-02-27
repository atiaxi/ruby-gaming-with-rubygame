require 'engine'
require 'ship'

def main
	engine = Engine.new
	engine.screen_width = 1024
	engine.screen_height = 768
	
	engine.screen
	
	ship = Ship.new
	engine.components << ship
	
	engine.run
end

if __FILE__ == $0
	main()
end

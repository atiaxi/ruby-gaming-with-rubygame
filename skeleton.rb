require 'rubygame'

include Rubygame

def main()
	Rubygame.init()
	flags = [HWSURFACE, DOUBLEBUF]
	
	screen = Screen.new( [640,480], 0, flags)
	
	clock = Clock.new
	clock.enable_tick_events()
	clock.target_framerate = 30
	
	queue = EventQueue.new()
	queue.enable_new_style_events()
	
	finished = false
	while not finished
		delay = clock.tick.seconds
		
		screen.fill( [0, 0, 0] )
		
		# TODO: Drawing
		screen.flip()
		
		queue.each do |event|
			case(event)
			when Events::QuitRequested
				finished = true
			end
		end
		
		# TODO: Updating
	end
end

if __FILE__ == $0
	main()
end

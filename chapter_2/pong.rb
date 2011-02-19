require 'rubygame'
require 'paddle'

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
	
	# Here's where we create our new paddle object, rather
	# than use a bunch of separate variables for the task
	paddle = Paddle.new("paddle.png")
	
	finished = false
	while not finished
		delay = clock.tick.seconds
		
		screen.fill( [0, 0, 0] )
		
		paddle.draw(screen)
		screen.flip()
		
		queue.each do |event|
			case(event)
			when Events::QuitRequested
				finished = true
			when Events::KeyPressed
				paddle.key(event.key, true)
			when Events::KeyReleased
				paddle.key(event.key, false)
			end
		end
		
		paddle.update(delay)
		
	end
end

if __FILE__ == $0
	main()
end

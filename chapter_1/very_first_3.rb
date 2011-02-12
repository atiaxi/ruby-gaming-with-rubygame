require 'rubygame'
include Rubygame
Rubygame.init()
# So that we can hold down the button and have it work
Rubygame.enable_key_repeat(0.5, 0.03)

flags = [ HWSURFACE, DOUBLEBUF ] 

screen = Screen.new( [640,480], 0, flags )
  
pic = Surface.load("rubygame.png")
pic = pic.convert()

queue = EventQueue.new()
queue.enable_new_style_events()


finished = false

# The location of our picture.
x = 0
y = 0

# How many pixels per second it'll move.
speed = 100

# The Clock object helps us move at a constant rate of speed, as we'll
# see later.
clock = Clock.new
# This is also going to become the default in Rubygame 3.0, so we might
# as well get used to it
clock.enable_tick_events()
# The clock lets us enter the amount of FPS we'd like.  It then slows
# us down to that number:
clock.target_framerate = 30


# The game loop!
while not finished

	# This is the number of seconds since last time we were here.
	# Knowing this number lets us smooth out motion correctly.
	delay = clock.tick.seconds

	# Clear the screen first
	screen.fill( [0,0,0] )

	pic.blit(screen, [x,y])
	screen.flip()

	queue.each do | event |
		case(event)
		when Events::QuitRequested
			finished = true
		when Events::KeyPressed
			# The 'key' field is a symbol
			if event.key == :up
				y -= speed * delay
			elsif event.key == :down
				y += speed * delay
			end
			if event.key == :left
				x -= speed * delay
			elsif event.key == :right
				x += speed * delay
			end
		when Events::MouseMoved
			# The 'pos' field is an array of the form [x,y] which
			# indicates where the mouse event happened.
			x = event.pos[0]
			y = event.pos[1]
		end
	end
end

Rubygame.quit()

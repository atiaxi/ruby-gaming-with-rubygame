require 'rubygame'
include Rubygame
Rubygame.init()

# Before we create the screen, we're going to make a list of options
# we'd like it to have:
flags = [ HWSURFACE,  # If at all possible, set it up on the video card.
                      # This is a lot faster than doing it in software.
	DOUBLEBUF, # If the hardware supports it, enable double buffering
	#FULLSCREEN ] # Use the whole screen!
]
screen = Screen.new( [640,480], # The size of the window we want
  0, # This is the color depth of the screen.  '0' uses whatever the
     # default is for the user's screen.
  flags) # These are the flags we were talking about earlier.
  
pic = Surface.load("rubygame.png")
# Convert the picture to the default color depth.  If we don't do this
# beforehand, it's going to do it anyway right before it draws the
# image.  Constant converting like that would slow things down hugely.
pic = pic.convert()

# Everything that happens while the game is running - keys pressed,
# joysticks moved, mice clicked, etc - comes to us in the form
# of events.  We go through them one by one using this queue:
queue = EventQueue.new()
# This is going to be the default in Rubygame 3.0, might as well
# get used to it
queue.enable_new_style_events()

# A simple flag to indicate we're done.
finished = false

# The game loop!
while not finished

	# Draw on the screen
	pic.blit(screen, [0,0])
	
	# If the hardware gods were kind to us and we got a hardware surface
	# with double-buffer support, we can take a shortcut.  Rather than
	# tell Rubygame what part of the screen was updated, we can tell it
	# that the whole screen changed, and to update everything at once:
	screen.flip()

	# Process all events that came up this time around.
	queue.each do | event |
		case(event)
		# This event happens whenever someone clicks the 'x' button.
		# Always respond to this, because it's rude not to.
		when Events::QuitRequested
			finished = true
		# This event happens whenever someone presses a key.
		when Events::KeyPressed
			# For the purposes of our demo, we're going to quit when this
			# happens.
			finished = true
		end
	end
end

Rubygame.quit()

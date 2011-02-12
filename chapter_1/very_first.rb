# Every rubygame program you run is going to require this
require 'rubygame'

# This is for convenience, so we don't have to go around typing
# Rubygame:: all the time
include Rubygame

# This sets up everything behind the scenes.  You only have to call it
# once, at the beginning.
Rubygame.init()

# Now the fun part - creating our game window!
screen = Screen.new( [640,480] ) # The size of the window we want

# Load a picture
pic = Surface.load("rubygame.png")

# Draw it to the screen
pic.blit(screen, # Surface to draw on,
  [0,0])         # and where to draw it
  
# Rubygame needs to know what part of the screen changed in order to re-
# draw it correctly.
screen.update(0,0,pic.w, pic.h)

# Wait for a bit before exiting
sleep(5)

# Before we exit out altogether, we need to tell Rubygame we're done.
# This is especially important in fullscreen applications!
Rubygame.quit()

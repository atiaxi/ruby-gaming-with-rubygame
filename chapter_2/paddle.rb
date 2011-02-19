require 'rubygame'

include Rubygame

class Paddle
	include Sprites::Sprite
	
	# Sprite already has an 'image' accessor for us, as well
	# as a 'rect' accessor that determines where the sprite is
	
	# It doesn't give us a speed, though, so we're going to have
	# to provide that ourselves
	attr_accessor :speed
	
	def initialize(filename)
		# If you use the default draw function that the Sprite
		# mixin provides (and we are in this example), then you
		# need to have an @image variable
		@image = Surface.load(filename).convert()
		@image.colorkey = [255, 0, 255]
		
		# This is a Rubygame Rectangle, and it provides us with all
		# kinds of useful functionality.  Like @image, it's required
		# for the Sprite mixin.
		@rect = Rect.new(0,0,@image.w, @image.h)
		
		@speed = 100
		
		# This will eventually hold the state of the entire keyboard
		@keys = {}
	end
	
	def key(sym, pressed)
		@keys[sym] = pressed
	end
	
	def move(dx, dy)
		@rect.move!(dx,dy)
	end
	
	def update(delay)
		amount = delay * @speed
		if @keys[:up]
			move(0,-amount)
		elsif @keys[:down]
			move(0, amount)
		end
		
		# As long as the screen's been created, you can get it
		# from anywhere in the program using this
		screen = Screen.get_surface()
		if @rect.top < 0
			@rect.top = 0
		end
		if @rect.bottom > screen.h
			@rect.bottom = screen.h
		end
	end
	
end

class AIPaddle < Paddle

	attr_accessor :ball
	
	def update(delay)
		if @ball
			@keys[:up] = @ball.rect.centery < @rect.centery - 10
			@keys[:down] = @ball.rect.centery > @rect.centery + 10
		end
		super(delay)
	end

end

require 'rubygame'

include Rubygame

class BareComponent
	include Sprites::Sprite
	
	def initialize
		super
	end
	
	def key(sym,pressed)
	end
	
	def draw(screen)
	end
	
	def update(delay)
	end
end

class Component
	include Sprites::Sprite
	
	def initialize(filename)
		@filename = filename
		Surface.autoload_dirs = ["."]
		initial = Surface[filename]
		if(!initial.colorkey)
			initial.colorkey = [255,0,255]
			Surface[filename] = initial.convert
		end
		@image = Surface[filename]
		
		@rect = Rect.new(0,0,@image.w, @image.h)
		@keys = {}
		super()
	end
	
	def colorkey=(key)
		@image.colorkey = key
	end
	
	def key(sym, pressed)
		@keys[sym] = pressed
	end
	
	def update(delay)

	end
end

class SpriteSheetComponent < Component

	def initialize(filename, srcrect)
		@srcrect = srcrect
		super(filename)
		@rect = Rect.new(0,0, srcrect.w, srcrect.h)
	end
	
	def draw(screen)
		@image.blit(screen, @rect.topleft, @srcrect)
	end

end

class InertialComponent < Component
	
	attr_accessor :top_speed
	attr_reader :velocity
	
	def initialize(filename)
		super
		@top_speed = 100
		@velocity = [ 0.0, 0.0 ]
	end
	
	def accelerate(dx,dy)
		@velocity[0] += dx
		@velocity[1] += dy
		
		# This is the part where we enforce the top speed
		speed_squared = @velocity[0] * @velocity[0] +
			@velocity[1] * @velocity[1]
		if speed_squared > @top_speed * @top_speed
			clamp_velocity(speed_squared)
		end
	end
	
	# If we're going faster than our top speed, change the speed to
	# be the top speed
	def clamp_velocity(speed_squared)
		speed = Math.sqrt(speed_squared)
		# Convert our velocity to a unit vector
		unit_x = @velocity[0] / speed
		unit_y = @velocity[1] / speed
		# Now scale it back up to the top speed
		@velocity = [unit_x * @top_speed, unit_y * @top_speed]
	end
	
	def update(delay)
		@rect.x += @velocity[0] * delay
		@rect.y += @velocity[1] * delay
	end
end

class Engine
	
	attr_accessor :flags
	attr_accessor :screen_width
	attr_accessor :screen_height
	attr_accessor :running
	attr_accessor :bgcolor
	
	attr_accessor :components
	
	def initialize()
		Rubygame.init()
		@flags = [HWSURFACE, DOUBLEBUF]
		@screen_width = 640
		@screen_height = 480
		
		@clock = Clock.new
		@clock.enable_tick_events()
		self.target_framerate=60
		
		@queue = EventQueue.new()
		@queue.enable_new_style_events()
		
		@bgcolor = [ 0, 0, 0 ]
		
		@components = Sprites::Group.new()
	end
	
	# Lazy initialization for screen
	def screen
		if not @screen
			resolution = [@screen_width, @screen_height]
			@screen = Screen.new( resolution, 0, @flags )
		end
		return @screen
	end
	
	def target_framerate=(value)
		@clock.target_framerate = value
	end
	
	def run
		@running = true
		while running
			delay = @clock.tick.seconds
			screen.fill( @bgcolor )
			
			@components.draw(screen)
			
			screen.flip()
			
			@queue.each do |event|
				case(event)
				when Events::QuitRequested
					@running = false
				when Events::QuitRequested
					finished = true
				when Events::KeyPressed
					@components.call(:key, event.key, true)
				when Events::KeyReleased
					@components.call(:key, event.key, false)
				end
			end
			
			@components.update(delay)
		end
	end
	
end

require 'engine'

class Asteroid < InertialComponent

	def initialize(angle = nil)
		super("asteroid.png")
		@speed = 100
		@angle = angle
		setup_direction
	end
	
	def setup_direction
		@angle ||= rand(360)
		angle = @angle  * Math::PI / 180
		
		@velocity[0] = Math.cos(angle) * @speed
		@velocity[1] = -Math.sin(angle) * @speed
	end
	
end

class AsteroidBelt < BareComponent
	attr_accessor :asteroids

	def initialize(engine)
		@engine = engine
		@asteroids = []
		super()
	end
	
	def spawn
		asteroid = Asteroid.new()
		screen = @engine.screen
		x = 0
		y = 0
		if(asteroid.velocity[0] < 0)
			x = @engine.screen.width + asteroid.rect.w
		else
			x = - asteroid.rect.w
		end
		
		if(asteroid.velocity[1] < 0)
			y = @engine.screen.height + asteroid.rect.h
		else
			y = - asteroid.rect.h
		end
		asteroid.rect.x = x
		asteroid.rect.y = y
		
		@engine.components << asteroid
		@asteroids << asteroid
	end
	
	def update(delay)
		while @asteroids.size < 5
			spawn
		end
	end

end

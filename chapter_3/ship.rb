require 'engine'

class Ship < InertialComponent

	attr_accessor :shots
	attr_reader :angle

	def initialize(engine)
		super("ship.png")
		@top_speed = 400
		@original_image = @image
		self.angle = 0
		@engine = engine
		@cooldown = 0
		@shots = []
	end
	
	def angle=(value)
		@angle = value
		@image = @original_image.rotozoom(@angle, 1.0).convert
		@image.colorkey = [255, 0, 255]
		
		# Because the image might end up a different size than before,
		# we need to change our @rect accordingly
		old_center = @rect.center
		@rect.w = @image.w
		@rect.h = @image.h
		@rect.center = old_center
	end
	
	def update(delay)
		radians = @angle * Math::PI / 180
	
		if @keys[:up]
			accelerate(Math.cos(radians) * 5,-Math.sin(radians) * 5)
		elsif @keys[:down]
			accelerate(-Math.cos(radians),Math.sin(radians))
		end
		
		if @keys[:left]
			self.angle = @angle + 90 * delay
		elsif @keys[:right]
			self.angle = @angle - 90 * delay
		end
		
		@cooldown -= delay if @cooldown > 0
		if @keys[:space] && @cooldown <= 0
			@cooldown = 1.0
			shot = Projectile.new(@engine,self)
			shot.rect.centerx = @rect.centerx
			shot.rect.centery = @rect.centery
			@engine.components << shot
			@shots << shot
		end
		super
	end
end

class Projectile < InertialComponent
	attr_reader :ship

	def initialize(engine, ship)
		super("projectile.png")
		@speed = 500
		@angle = ship.angle
		@life = 2
		@engine = engine
		setup_direction
		@ship = ship
	end
	
	def setup_direction
		angle = @angle * Math::PI / 180
		@velocity[0] = Math.cos(angle) * @speed
		@velocity[1] = -Math.sin(angle) * @speed
	end
	
	def update(delay)
		super(delay)
		@life -= delay
		if(@life < 0)
			@engine.components.delete(self)
			@ship.shots.delete(self)
		end
	end
	
end

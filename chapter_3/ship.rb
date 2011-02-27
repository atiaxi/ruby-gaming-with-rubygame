require 'engine'

class Ship < InertialComponent

	def initialize
		super("ship.png")
		@top_speed = 400
		@original_image = @image
		self.angle = 0
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
		super
	end
end

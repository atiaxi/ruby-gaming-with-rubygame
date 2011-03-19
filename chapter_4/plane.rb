require 'engine'

class PlayerPlane < SpriteSheetComponent

	def initialize(filename, srcrect)
		super
		reset
	end
	
	def reset
		@speed = 350
	end

	def update(delay)
		change = delay * @speed
		
		if @keys[:left]
			@rect.x -= change
		elsif @keys[:right]
			@rect.x += change
		end
		
		if @keys[:up]
			@rect.y -= change
		elsif @keys[:down]
			@rect.y += change
		end
	end

end

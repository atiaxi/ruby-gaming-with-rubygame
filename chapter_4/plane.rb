require 'engine'

class PlayerPlane < SpriteSheetComponent

	def initialize(filename, srcrect)
		super
		reset
	end
	
	def reset
		@speed = 350
		
		screen = Screen.get_surface()
		@rect.center = [screen.w / 2, @rect.height]
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

class EnemyPlane < SpriteSheetComponent

	def initialize(filename,srcrect)
		super
		@speed = 350
		@waypoint = nil
	end
	
	def close_to_waypoint?
		if @waypoint
			dx = @waypoint[0] - @rect.x
			dy = @waypoint[1] - @rect.y
			
			if (dx+dy) < @rect.w / 2
				return true
			end
		end
		return false
	end
	
	def pick_waypoint
		@waypoint = [ 500,500]
	end
	
	def update(delay)
		if @waypoint == nil || close_to_waypoint?
			pick_waypoint
		end
		
		dx = (@waypoint[0] - @rect.x).sign
		dy = (@waypoint[1] - @rect.y).sign
		
		x_impulse = dx * delay * @speed
		puts "dx: #{dx}, delay: #{delay}, speed: #{@speed} -> #{x_impulse}"
		
		@rect.x += dx * delay * @speed
		@rect.y += dy * delay * @speed
		
	end
end

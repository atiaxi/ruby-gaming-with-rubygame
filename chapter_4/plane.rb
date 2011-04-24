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
		
		@rect.x += dx * delay * @speed
		@rect.y += dy * delay * @speed
		
	end
end

class AirTrafficControl < BareComponent

	TIME_BETWEEN_SHIPS = 0.5

	def initialize(engine)
		super()
		@engine = engine
		@wave = 0
		@active_ships = []
		@time_to_next_ship = 0
		begin_wave
	end
	
	def begin_wave
		@ships_to_spawn = @wave + 5
		@wave += 1
	end
	
	def check_spawn_ship
		@time_to_next_ship = TIME_BETWEEN_SHIPS
		if @ships_to_spawn > 0
			@ships_to_spawn -= 1
			spawn_ship
		end
	end
	
	def spawn_ship
		src = Rect.new(499,4,98,98)
		baddie = EnemyPlane.new("1945.bmp",src)
		baddie.colorkey = [0, 67, 171]
		@engine.components << baddie
		@active_ships << baddie
	end
	
	def update(delay)
		@time_to_next_ship -= delay
		if @time_to_next_ship <= 0
			check_spawn_ship
		end
	end
end

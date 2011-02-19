require 'rubygame'

include Rubygame

class Ball
	include Sprites::Sprite
	
	def initialize(filename, paddles)
		@image = Surface.load(filename).convert()
		@image.colorkey = [255,0,255]
		
		@rect = Rect.new(0,0,@image.w, @image.h)
		@paddles = paddles
		reset
	end
	
	def bounce(index)
		@direction[index] = -@direction[index]
		@speed *= 1.1
	end
	
	def check_collision
		screen = Screen.get_surface()
		if(@rect.top <= 0 or @rect.bottom > screen.h)
			bounce(1)
		end
		
		if(@rect.left <= 0)
			announce_score(1)
			reset
		end
		if(@rect.right >= screen.w)
			announce_score(0)
			reset
		end
		
		@paddles.each do |paddle|
			if collide_sprite?(paddle)
				bounce(0)
			end
		end
	end
	
	def announce_score(index)
		if @score_callback
			@score_callback.call(index)
		end
	end
	
	def when_score(&block)
		@score_callback = block
	end
	
	def reset
		screen = Screen.get_surface()
		@rect.center = [screen.w/2, screen.h / 2]
		@direction = [-1.0, -1.0]
		@speed = 150
	end
	
	def update(delay)
		amount = delay * @speed
		
		@rect.x += @direction[0] * amount;
		@rect.y += @direction[1] * amount;
		
		check_collision
	end
end

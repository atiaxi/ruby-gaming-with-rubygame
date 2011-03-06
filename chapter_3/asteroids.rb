require 'engine'
require 'ship'
require 'asteroid'

class WraparoundWatcher < BareComponent

	def initialize(engine)
		@engine = engine
		super()
	end
	
	def update(delay)
		@engine.components.each do |item|
			if item.rect
				if item.rect.right < 0
					item.rect.left = @engine.screen.w
				elsif item.rect.left > @engine.screen.w
					item.rect.right = 0
				end
				
				if item.rect.bottom < 0
					item.rect.top = @engine.screen.h
				elsif item.rect.top > @engine.screen.h
					item.rect.bottom = 0
				end
			end
		end
	end

end

class CollisionWatcher < BareComponent
	def initialize(engine,ship,belt)
		@engine = engine
		@ship = ship
		@belt = belt
		super()
	end
	
	def update(delay)
		shots = @ship.shots.dup
		if(@ship.rect)
			@belt.asteroids.dup.each do |rock|
				if rock.rect.collide_rect?(@ship.rect)
					game_over
					return unless @ship.rect
				end
				shots.each do |shot|
					if shot.rect.collide_rect?(rock.rect)
						kill_both(rock,shot)
					end
				end
			end
		end
	end
	
	def game_over
		over = Component.new("gameover.png")
		@engine.components << over
		over.rect.centerx = @engine.screen.w / 2
		over.rect.centery = @engine.screen.h / 2
		@engine.components.delete(@ship)
		@ship.rect = nil
	end
	
	def kill_both(rock, shot)
		@engine.components.delete(rock)
		@engine.components.delete(shot)
		@ship.shots.delete(shot)
		@belt.asteroids.delete(rock)
	end
end


def main
	engine = Engine.new
	engine.screen_width = 1024
	engine.screen_height = 768
	
	engine.screen
	
	ship = Ship.new(engine)
	ship.rect.centerx = engine.screen_width / 2
	ship.rect.centery = engine.screen_height / 2
	engine.components << ship
	
	belt = AsteroidBelt.new(engine)
	engine.components << belt
	
	watcher = CollisionWatcher.new(engine,ship,belt)
	engine.components << watcher
	
	wrap = WraparoundWatcher.new(engine)
	engine.components << wrap
	
	engine.run
end

if __FILE__ == $0
	main()
end

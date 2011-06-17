require 'engine'

class Projectile < SpriteSheetComponent

	attr_accessor :faction

	def initialize(faction)
		@faction = faction
		@speed = 700
		super("1945.bmp",srcrect_for_faction)
	end
	
	def srcrect_for_faction()
		if(@faction == :player)
			return Rect.new(4,202,32,32)
		else
			return Rect.new(4, 169,32,32)
		end
	end
	
	def update(delay)
		if(@faction == :player)
			@rect.y += @speed * delay
		else
			@rect.y -= @speed * delay
		end
	end

end

module Shooter

	def can_shoot?
		@cooldown ||= 0
		return @cooldown <= 0
	end
	
	def shoot(atc)
		if can_shoot?
			projectile = Projectile.new(@faction)
			projectile.rect.centerx = @rect.centerx
			projectile.rect.centery = @rect.centery
			atc.add_shot(projectile)
			@cooldown = 0.5
		end
	end
	
	def update(delay)
		super
		@cooldown ||= 0
		@cooldown -= delay
	end

end

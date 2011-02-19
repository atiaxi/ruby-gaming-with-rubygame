require 'rubygame'

include Rubygame

class Scoreboard

	include Sprites::Sprite
	
	attr_reader :score
	
	def initialize(filename, initial_score = 0)
		@font = TTF.new(filename, 18)
		@rect = Rect.new(0,0,0,0)
		self.score = initial_score
	end
	
	def score=(new_score)
		@score = new_score
		@image = @font.render(
			@score.to_s,     # The text to render
			true,            # Do we want antialiasing?
			[255,255,255])   # The color of the text
		@rect.w = @image.w
		@rect.h = @image.h
	end

end

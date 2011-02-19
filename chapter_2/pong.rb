require 'rubygame'
require 'paddle'
require 'ball'
require 'score'

include Rubygame

def main()
	Rubygame.init()
	Rubygame::TTF.setup()
	flags = [HWSURFACE, DOUBLEBUF]
	
	screen = Screen.new( [640,480], 0, flags)
	
	clock = Clock.new
	clock.enable_tick_events()
	clock.target_framerate = 30
	
	queue = EventQueue.new()
	queue.enable_new_style_events()
	
	# Here's where we create our new paddle object, rather
	# than use a bunch of separate variables for the task
	paddle = Paddle.new("paddle.png")
	paddle2 = AIPaddle.new("paddle.png")
	paddle2.rect.right = screen.w
	ball = Ball.new("ball.png", [paddle,paddle2])
	paddle2.ball = ball
	scores = [
		Scoreboard.new("VeraMoBd.ttf"),
		Scoreboard.new("VeraMoBd.ttf")
	]
	scores[0].rect.x = 60
	scores[1].rect.right = screen.w - 60
	
	ball.when_score do |index|
		scores[index].score += 1
	end
	
	finished = false
	while not finished
		delay = clock.tick.seconds
		
		screen.fill( [0, 0, 0] )
		
		paddle.draw(screen)
		paddle2.draw(screen)
		ball.draw(screen)
		scores.each do |board|
			board.draw(screen)
		end
		screen.flip()
		
		queue.each do |event|
			case(event)
			when Events::QuitRequested
				finished = true
			when Events::KeyPressed
				paddle.key(event.key, true)
			when Events::KeyReleased
				paddle.key(event.key, false)
			end
		end
		
		paddle.update(delay)
		paddle2.update(delay)
		ball.update(delay)
		
		if scores[0].score > 15
			raise "Game over - you win!"
		end
		
		if scores[1].score > 15
			raise "Game over - you lose!"
		end
		
	end
end

if __FILE__ == $0
	main()
end

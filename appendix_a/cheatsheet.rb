require 'rubygame'
include Rubygame
Rubygame.init()

screen = Screen.new( [640,480] ) # The size of the window we want

queue = EventQueue.new()
queue.enable_new_style_events()

finished = false
while not finished

	queue.each do | event |
		case(event)
		when Events::QuitRequested
			finished = true
		when Events::KeyPressed
			puts "#{event.string} pressed, "+
				"mods are: #{event.modifiers.join(',')} "+
				"symbol is: :#{event.key}"
		end
	end
	Clock.wait(100)
end


Rubygame.quit()

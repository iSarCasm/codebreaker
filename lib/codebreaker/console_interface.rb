module Codebreaker
  class ConsoleInterface
    def initialize
      puts "Welcome, my friend to the truly advanced CodeBreaker by SarCasm!"
      puts "
 _______  _______  ______   _______  _______  ______    _______  _______  ___   _  _______  ______
|       ||       ||      | |       ||  _    ||    _ |  |       ||   _   ||   | | ||       ||    _ |
|       ||   _   ||  _    ||    ___|| |_|   ||   | ||  |    ___||  |_|  ||   |_| ||    ___||   | ||
|       ||  | |  || | |   ||   |___ |       ||   |_||_ |   |___ |       ||      _||   |___ |   |_||_
|      _||  |_|  || |_|   ||    ___||  _   | |    __  ||    ___||       ||     |_ |    ___||    __  |
|     |_ |       ||       ||   |___ | |_|   ||   |  | ||   |___ |   _   ||    _  ||   |___ |   |  | |
|_______||_______||______| |_______||_______||___|  |_||_______||__| |__||___| |_||_______||___|  |_|
      "
      session  = Game.new
      puts "Select difficulty #{Game::GAME_SETTINGS.keys.inspect.delete(':')}"
      diff = gets.chomp
      puts "\nThe game starts right now!"
      session.start diff.to_sym
	    loop do
	      puts "
	      Symbol range: #{session.symbols_range}
	      Symbols:      #{session.symbols_count}
	      Attempts:     #{session.attempts}
	      Hints:        #{session.hints_left}"
	      loop do
	        print "Your guess: "
	        guess = gets.chomp
	        if guess == 'hint'
	          p session.hint.map {|x| x.is_a?(Fixnum) ? x.to_s(16) : '*'}
	        else
            begin
              code = guess.split('').map {|x| x.to_i(16) }
              response = session.guess code
  	          puts '+' * response[0] + '-' * response[1]
            rescue IndexError
              puts 'Wrong number of arguments'
              next
            end
	        end
	        break unless session.state == :playing
	      end
	      if session.state == :won
	        puts "You won!"
	        puts "It took you #{session.max_attempts - session.attempts} guesses"
	        puts "Your score is: #{session.score}"
	      elsif session.state == :lost
	        puts "You lost, noob :("
          puts "The answer was #{session.secret}"
	      end
	      puts 'Wanna replay? (y/n)'
	      answer = gets.chomp
	      if answer == 'y'
	      	session.restart
	      	next
	      else
	      	break
	      end
	    end
	    puts "Bye!"
    end
  end
end

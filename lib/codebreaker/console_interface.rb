module Codebreaker
  class ConsoleInterface

    MAX_SYM_RANGE = 16

    Welcome_text      = 'Welcome, my friend to the truly advanced CodeBreaker by SarCasm!'
    Welcome_screen    = '
_______  _______  ______   _______  _______  ______    _______  _______  ___   _  _______  ______
|       ||       ||      | |       ||  _    ||    _ |  |       ||   _   ||   | | ||       ||    _ |
|       ||   _   ||  _    ||    ___|| |_|   ||   | ||  |    ___||  |_|  ||   |_| ||    ___||   | ||
|       ||  | |  || | |   ||   |___ |       ||   |_||_ |   |___ |       ||      _||   |___ |   |_||_
|      _||  |_|  || |_|   ||    ___||  _   | |    __  ||    ___||       ||     |_ |    ___||    __  |
|     |_ |       ||       ||   |___ | |_|   ||   |  | ||   |___ |   _   ||    _  ||   |___ |   |  | |
|_______||_______||______| |_______||_______||___|  |_||_______||__| |__||___| |_||_______||___|  |_|
    '
    Game_start_text   = '\nThe game starts right now!'
    Diff_select_text  = 'Select difficulty'
    Same_diff_tex     = '[Enter] to play same difficulty'
    IndexErorr_text   = 'Wrong number of arguments'
    Guesses_took_0    = 'It took you'
    Guesses_took_1    = 'guesses'
    Score_is_text     = 'Your score is:'
    The_answer_text   = 'The answer was'
    Win_text          = 'You won!'
    Lose_text         = 'You lost, noob :('
    Replay_text       = 'Wanna replay? (y/n)'
    Bye_text          = 'Bye!'


    def initialize
      welcome
	    play
      goodbye
    end

    def welcome
      puts Welcome_text
      puts Welcome_screen
      @session  = Game.new
    end

    def play
      loop do
        select_difficulty
        difficulty_info
        guessing
        @played = true
        results
        ask_for_replay == 'y' ? next : break
      end
    end

    def select_difficulty
      puts "#{Diff_select_text} #{Game::GAME_SETTINGS.keys.inspect.delete(':')}"
      puts Same_diff_tex if @played
      diff = gets
      puts Game_start_text
      if @played && diff == "\n"
        @session.restart
      else
        diff.chomp!
        @session.start diff.to_sym
      end
    end

    def difficulty_info
      puts "
      Symbol range: #{@session.symbols_range}
      Symbols:      #{@session.symbols_count}
      Attempts:     #{@session.attempts}
      Hints:        #{@session.hints_left}"
    end

    def guessing
      loop do
        print "Your guess: "
        guess = gets.chomp
        if guess == 'hint'
          p @session.hint.map {|x| x.is_a?(Fixnum) ? x.to_s(MAX_SYM_RANGE) : '*'}
        else
          begin
            code = guess.split('').map {|x| x.to_i(MAX_SYM_RANGE) }
            response = @session.guess code
            puts '+' * response[0] + '-' * response[1]
          rescue IndexError
            puts IndexErorr_text
            next
          end
        end
        break unless @session.state == :playing
      end
    end

    def results
      if @session.state == :won
        puts Win_text
        puts "#{Guesses_took_0} #{@session.max_attempts - @session.attempts} #{Guesses_took_1}"
        puts "#{Score_is_text} #{@session.score}"
      elsif @session.state == :lost
        puts Lose_text
        puts "#{The_answer_text} #{@session.secret}"
      end
    end

    def ask_for_replay
      puts Replay_text
      answer = gets.chomp
    end

    def goodbye
      puts Bye_text
    end
  end
end

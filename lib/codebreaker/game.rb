module Codebreaker
  class Game
    attr_accessor(:max_attempts, :state, :score,
    							:attempts, :answer, :hints_left)

    GAME_SETTINGS = { easy: 			{ attempts: 10, symbols_count: 3, symbols_range: 6, 	hints: 3 },
    									medium: 		{ attempts: 10, symbols_count: 4, symbols_range: 6, 	hints: 1 },
    									hard: 			{ attempts: 20, symbols_count: 6, symbols_range: 6, 	hints: 1 },
    									very_hard: 	{ attempts: 25, symbols_count: 4, symbols_range: 15, 	hints: 1 },
    									gosu: 			{ attempts: 35, symbols_count: 6, symbols_range: 15, 	hints: 0 },
    									mlg: 				{ attempts: 1, 	symbols_count: 4, symbols_range: 6, 	hints: 0 } }

    def initialize
      @state = :initialized
    end

    def start(diff = :medium)
    	@settings = GAME_SETTINGS[diff]
      @max_attempts 			= @settings[:attempts]
      @attempts 					= @max_attempts
      @symbols_count 			= @settings[:symbols_count]
      @symbols_range 			= @settings[:symbols_range]
      @answer 						= generate_code
      @hints_left 				= @settings[:hints]
      @elements_revealed 	= []
      @state 							= :playing
    end

    def restart
    	start(@settings)
    end

    def guess(code)
      fail IndexError if code.length != @answer.length

      if code == @answer
        win
      else
        @attempts -= 1
        lose if @attempts.zero?
        respond = 	extract_exact_matches(code)
        respond +=	extract_close_matches(code)
        respond.sort
      end
    end

    def win
      @score = (10 - @attempts) * @symbols_count * @symbols_range + @hints_left*20
      @state = :won
    end

    def lose
      @score = 0
      @state = :lost
    end

    def hint
      unless @hints_left.zero?
        random_symbol_index = 0
      	loop do
	        random_symbol_index = rand(@answer.size)
	        break unless @elements_revealed.include? random_symbol_index
	      end
	      @elements_revealed << random_symbol_index
	      @hints_left -= 1
	      hint = (['*']*@answer.size)
	      hint[random_symbol_index] = @answer[random_symbol_index]
	      hint
	    end
    end

    private
  	def extract_exact_matches(guess)
  		matches = []
  		guess.each_index do |i|
  			if guess[i] == @answer[i]
  				matches << '+'
  				guess.delete_at(i)
  			end
  		end
  		matches
  	end

  	def extract_close_matches(guess)
  		matches = []
  		guess.each do |sym|
  			if @answer.include? sym
  				matches << '-'
  			end
  		end
  		matches
  	end

    def generate_code
      @symbols_count.times.with_object([]) do |n, code|
        code << (1..@symbols_range).to_a.sample.to_s
      end
    end
  end
end

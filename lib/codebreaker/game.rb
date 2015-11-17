module Codebreaker
  class Game
    attr_reader(:max_attempts, :state, :score, :secret,
    							:attempts, :secret, :hints_left, :elements_revealed,
                  :symbols_count, :symbols_range)

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
    	@settings = diff
      settings = GAME_SETTINGS[diff]
      @max_attempts 			= settings[:attempts]
      @attempts 					= @max_attempts
      @symbols_count 			= settings[:symbols_count]
      @symbols_range 			= settings[:symbols_range]
      @secret 						= generate_code
      @hints_left 				= settings[:hints]
      @elements_revealed 	= []
      @state 							= :playing
    end

    def restart
    	start(@settings)
    end

    def guess(code)
      fail IndexError if code.length != @secret.length

      if code == @secret
        win
      else
        @attempts -= 1
        lose if @attempts.zero?
      end
      secret = @secret.dup
      [extract_exact_matches(secret, code), extract_close_matches(secret, code)]
    end

    def win?
      @state == :won
    end
    alias_method :won?, :win?

    def lose?
      @state == :lost
    end
    alias_method :lost?, :lose?

    def win
      @score = (10 - @attempts) * @symbols_count * @symbols_range + @hints_left*20
      @state = :won
    end

    def lose
      @score = 0
      @state = :lost
    end

    def hint
      if @hints_left.zero?
        fail 'No more hints available'
      else
        random_symbol_index = 0
      	loop do
	        random_symbol_index = rand(@secret.size)
	        break unless @elements_revealed.include? random_symbol_index
	      end
	      @elements_revealed << random_symbol_index
	      @hints_left -= 1
	      hint = ([nil]*@secret.size)
	      hint[random_symbol_index] = @secret[random_symbol_index]
	      hint
	    end
    end

    private
  	def extract_exact_matches(secret, guess)
  		matches = 0
      guess_dup = guess.dup
  		guess_dup.each_index do |i|
  			if guess_dup[i] == @secret[i]
  				matches += 1
  				guess[i]  = nil
          secret[i] = nil
  			end
  		end
      secret.compact!
      guess.compact!
  		matches
  	end

  	def extract_close_matches(secret, guess)
  		matches = 0
  		guess.each.with_index do |sym, i|
  			if secret.include? sym
  				matches +=1
          secret[ secret.index(sym) ] = nil
  			end
  		end
  		matches
  	end

    def generate_code
      @symbols_count.times.with_object([]) do |n, code|
        code << (1..@symbols_range).to_a.sample
      end
    end
  end
end

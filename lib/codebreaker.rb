require "codebreaker/version"

module Codebreaker
  class ConsoleInterface
    
  end

  class Game
    attr_accessor( :max_attempts, :player_name,
                   :state, :score, :attempts, :answer,
                   :hints, :player_name )
    def initialize(attempts = 10)
      @max_attempts = attempts
      @state = :initialized
    end

    def start
      @attempts = @max_attempts
      @answer = generate_code(4)
      @hints = 0
      @elements_revealed = []
      @state = :in_process
    end

    def guess(code)
      fail IndexError if code.length != @answer.length

      if code == @answer
        win
      else
        @attempts -= 1
        lose if @attempts.zero?
        respond = []
        code.each.with_index do |c, i|
          if c == @answer[i]
            respond << '+'
          elsif @answer.include? c
            respond << '-'
          end
        end
        respond.sort
      end
    end

    def win
      @score = (10 - @attempts) * 4 * 6 - @hints*20
      @state = :won
    end

    def lose
      @score = 0
      @state = :lost
    end

    def hint
      random_code_element = 0
      loop do
        random_code_element = rand(@answer.size)
        break unless @elements_revealed.include? random_code_element
      end
      @elements_revealed << random_code_element
      @hints += 1
      hint = (['*']*@answer.size)
      hint[random_code_element] = @answer[random_code_element]
      hint
    end

    private
      def generate_code(length = 4)
        length.times.with_object([]) do |n, code|
          code << (1..6).to_a.sample
        end
      end
  end
end

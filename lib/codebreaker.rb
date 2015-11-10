require "codebreaker/version"

module Codebreaker
  class ConsoleInterface
    def initialize
      puts "Welcome, my friend to the trule advanced CodeBreaker by SarCasm!"
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
      puts "\nThe game starts right now!"
      session.start
      puts "
      Symbol range: 1-6
      Symbols:      4
      Attempts:     10"
      loop do
        print "Your guess: "
        guess = gets.chomp
        if guess == 'hint'
          puts session.hint
        else
          puts session.guess guess.split('').map {|x| x.to_i }
        end
        break if session.state != :in_process
      end
      if session.state == :won
        puts "You won!"
        puts "It took you #{session.max_attempts - session.attempts} guesses"
        puts "Your score is: #{session.score}"
      elsif session.state == :lost
        puts "You lost, noob :("
      end
    end
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

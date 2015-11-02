require "codebreaker/version"

module Codebreaker
  class Game
    attr_accessor :attempts, :answer
    def initialize
      # Nothing here..
    end

    def start
      @attempts = 10
      @answer = generate_code(4)
      @elements_revealed = []
    end

    def guess(code)
      fail IndexError if code.length != @answer.length

      return win if code == @answer
      @attempts -= 1
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

    def win
      @score = (10 - @attempts) * 4 * 6
      "You won! The code was #{@answer}.\nIt took you #{10 - @attempts} attempts.\nYou'r score is #{@score}.\nWrite you'r name:"
      save_score(gets.chomp)
    end

    def lose
      "You lost :(\nTry again later."
    end

    def hint
      random_code_element = 0
      loop do
        random_code_element = rand(@answer.size)
        break unless @elements_revealed.include? random_code_element
      end
      @elements_revealed << random_code_element
      hint = (['*']*@answer.size)
      hint[random_code_element] = @answer[random_code_element]
      hint
    end

    def save_score(name)
      datebase = File.new('scores','r') do |file|
        file.puts "#{name} #{@score}"
      end
    end

    def generate_code(length = 4)
      length.times.with_object([]) do |n, code|
        code << (1..6).to_a.sample
      end
    end
  end
end

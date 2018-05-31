require 'date'
require 'yaml'

module Codebreaker
  class Game
    HINTS = 3
    ATTEMPTS = 10

    def initialize
      @secret_code = []
      @breaker_code = []
      @hints_count = HINTS
      @attempts_remain = ATTEMPTS
    end

    def start
      @secret_code = Array.new(4) { rand(1..6) }
    end

    def win?
      @breaker_code == @secret_code
    end

    def lose?
      @attempts_remain == 0
    end

    def game_over?
      win? || lose?
    end

    def hints
      return p 'No hints remains' if @hints_count.zero?
      hint = @secret_code - @breaker_code
      return p 'You guessed all numbers, try swap them' if hint.empty?
      p "HINT: #{hint.sample}, #{@hints_count -= 1} hints remains"
    end

    def secret
      @secret_code.join
    end

    # TODO: #check
    def code_check(code)
      @breaker_code = code.split('').map(&:to_i)

      result = @breaker_code.map.with_index { |v, i|
        if @secret_code.include?(v)
          @secret_code[i] == v ? '+' : '-'
        end
      }.compact.sort.join(' ')

      p "Attempt result: #{result}"
      p "Remaining attempts: #{@attempts_remain -= 1}"
    end

    def save_result
      p 'Input your name: '
      codebreaker_name = gets.chomp
      game_data = {
        game_date: Date.today.to_s,
        player_name: codebreaker_name,
        attempts: "#{ATTEMPTS - @attempts_remain}",
        result: win? ? 'won' : 'lost'
      }
      File.open('game_data.yml', 'w') { |f| f.write YAML.dump(game_data) }
    end
  end
end

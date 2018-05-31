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
      # @secret_code = Array.new(4) { rand(1..6) }
      @secret_code = [1, 2, 1, 3]
    end

    def win?
      @breaker_code == @secret_code
    end

    def lose?
      @attempts_remain.zero?
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

    def code_check(code)
      result = []
      @breaker_code = code.split('').map(&:to_i)
      if @breaker_code == @secret_code
        result << %w[+ + + +]
      else
        intersection = @breaker_code & @secret_code
        unless intersection.empty?
          result = intersection.map.each do |v|
            @breaker_code.index(v) == @secret_code.index(v) ? '+' : '-'
          end
        end
      end

      p "Attempt result: #{result.sort.join}"
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

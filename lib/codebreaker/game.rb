require 'date'
require 'yaml'

module Codebreaker
  class Game
    HINTS = 3
    ATTEMPTS = 10
    attr_reader :attempt_result
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

    def lost?
      @attempts_remain.zero?
    end

    def game_over?
      win? || lost?
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
      @breaker_code = code.chars.map(&:to_i)
      secret = @secret_code
      # # @breaker_code = code.to_i.digits.reverse
      # if @breaker_code == @secret_code
      #   result << %w[+ + + +]
      # else
      #   intersection = @breaker_code & @secret_code
      #   unless intersection.empty?
      #     result = intersection.map.each do |v|
      #       @breaker_code.index(v) == @secret_code.index(v) ? '+' : '-'
      #     end
      #   end
      # end

      # inner_code, inner_secret = [], []

      @breaker_code.each_with_index do |v, i|
        if @secret_code[i] == v
          result << '+'
          secret.delete_at(i)
        end
      end
@breaker_code.each do |v|

if
          secret.include?(v)
          result << '-'
end
end

      @attempts_remain -= 1
      @attempt_result = result.sort.join
    end

    def show_attempt_result
      p "Attempt result: #{@attempt_result}"
      p "Remaining attempts: #{@attempts_remain}"
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

g = Codebreaker::Game.new
p g.start
code = '1235'
g.code_check(code)
g.show_attempt_result

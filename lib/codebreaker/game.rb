require 'date'
require 'yaml'

module Codebreaker
  class Game
    HINTS = 3
    ATTEMPTS = 10
    attr_reader :hints_count, :attempt_result, :attempts_remain
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

    def hint
      @hints_count -= 1
      (@secret_code - @breaker_code).sample unless @hints_count <= 0
    end

    def secret
      @secret_code.join
    end

    def code_check(code)
      result = []
      loc_code = []
      loc_secret = []
      @breaker_code = code.chars.map(&:to_i)

      @breaker_code.each_with_index do |v, i|
        if @secret_code[i] == v
          result << '+'
        else
          loc_code << v
          loc_secret << @secret_code[i]
        end
      end
      (loc_secret & loc_code).compact.count.times { result << '-' }

      @attempts_remain -= 1
      @attempt_result = result.sort.join
    end
    def save_result
      # p 'Input your name: '
      # codebreaker_name = gets.chomp
      game_data = {
        game_date: Date.today.to_s,
        player_name: codebreaker_name,
        attempts: (ATTEMPTS - @attempts_remain).to_s,
        result: win? ? 'won' : 'lost'
      }
      File.open('./lib/game_data.yml', 'a+') { |f| f.write YAML.dump(game_data) }
    end
  end
end

# c = Codebreaker::Game.new
# c.instance_variable_set(:@secret_code, [1,2,3,4])
# c.instance_variable_set(:@breaker_code, [1,2,5,4])
# c.instance_variable_set(:@hints_count, 0)

# p c.hint

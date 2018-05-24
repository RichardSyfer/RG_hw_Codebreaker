module Codebreaker
  class Game
    def initialize
      @secret_code = ''
    end

    def start
      @secret_code = Array.new(4) { rand(1..6) }
    end

    def code_check(code)
      if code.match(/^[1-6]{4}$/)
        code.split('').map.with_index { |v, i|
          if @secret_code.include?(v.to_i)
            @secret_code[i] == v.to_i ? '+' : '-'
          end
        }.compact.sort.join(' ')
      else
        warn 'Incorrect input'
      end
    end
  end
end

# game =Codebreaker::Game.new
# p sc = game.start
# p code = '1234'
# p game.code_check(code)

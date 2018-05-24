module Codebreaker
  class Game
    def initialize
      @secret_code = ''
    end

    def start
      @secret_code = Array.new(4).map { rand(1..7) }
    end
  end
end

module Codebreaker
  class GameCodeChecker
    def initialize(secret_code, breaker_input)
      @secret = secret_code.chars
      @breaker_code = breaker_input.chars
    end

    def check_result
      return '++++' if @secret == @breaker_code
      (exact_matches + matches).join
    end

    def exact_matches
      @breaker_code.each_with_index.map do |v, i|
        if @secret[i] == v
          @breaker_code[i] = nil
          @secret[i] = nil
          '+'
        else
          next
        end
      end
    end

    def matches
      (@breaker_code & @secret).compact.map { '-' }
    end
  end
end

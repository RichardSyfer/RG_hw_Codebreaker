module Codebreaker
  class GameCodeChecker
    WINNER_RESULT = '++++'.freeze

    def initialize
      @secret, @breaker_code = '', ''
    end

    def check_result(secret_code, breaker_input)
      @secret = secret_code.chars
      @breaker_code = breaker_input.chars
      return WINNER_RESULT if @secret == @breaker_code
      (exact_matches + matches).join
    end

    def exact_matches
      @breaker_code.each_with_index.map do |v, i|
        next unless @secret[i] == v
        @breaker_code[i] = nil
        @secret[i] = nil
        '+'
      end
    end

    def matches
      (@breaker_code & @secret).compact.map { '-' }
    end
  end
end

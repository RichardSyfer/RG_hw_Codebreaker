require 'date'
require 'yaml'

module Codebreaker
  class Game
    HINTS = 3
    ATTEMPTS = 10
    attr_reader :hints_count, :attempt_result, :attempts_remain

    def initialize(player_name)
      @codebreaker_name = player_name
      @secret_code = ''
      @hints_count = HINTS
      @attempts_remain = ATTEMPTS
      @game_data_file_path = File.join(__dir__, 'game_data.yml')
    end

    def start
      @secret_code = Array.new(4) { rand(1..6) }.join
    end

    def won?
      @attempt_result == '++++'
    end

    def lost?
      @attempts_remain.zero? && !won?
    end

    def game_over?
      won? || lost?
    end

    def game_state
      return 'pending' unless game_over?
      return 'won' if won?
      'lost' if lost?
    end

    def valid_attempt?(code)
      code =~ /^[1-6]{4}$/ ? true : false
    end

    def make_attempt(code)
      return if game_over?
      @attempts_remain -= 1
      @attempt_result = GameCodeChecker.new(@secret_code, code).check_result
    end

    def hint
      @hints_count -= 1
      @secret_code.chars.sample unless @hints_count <= 0
    end

    def secret
      @secret_code
    end

    def game_data
      {
        game_date: Date.today.to_s,
        player_name: @codebreaker_name,
        result: game_state,
        secret_code: secret,
        attempt_result: @attempt_result,
        attempts: (ATTEMPTS - @attempts_remain).to_s,
        hints_left: @hints_count
      }
    end

    def save_result
      File.open(@game_data_file_path, 'w') { |f| f.write YAML.dump(game_data) }
    end

    def load_game_score
      YAML.load(File.open(@game_data_file_path, 'r')) if File.file?(@game_data_file_path)
    end

    def erase_game_score
      File.delete(@game_data_file_path) if File.file?(@game_data_file_path)
    end
  end
end

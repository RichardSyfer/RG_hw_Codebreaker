module Codebreaker
  class Hmi
    HMI_CMD = {
      'help' => ->(instance) { instance.hmi_cmd_help },
      'hint' => ->(instance) { instance.hmi_cmd_hint },
      'save' => ->(instance) { instance.hmi_cmd_save },
      'replay' => ->(instance) { instance.hmi_cmd_replay },
      'exit' => ->(instance) { instance.hmi_cmd_exit },
      'show_score' => ->(instance) { instance.hmi_cmd_show_score },
      'show_scores' => ->(instance) { instance.hmi_cmd_show_scores },
      'erase_scores' => ->(instance) { instance.hmi_cmd_erase_scores }
    }

    def initialize
      @game_stop = false
      @message = GameAppMessages.new
    end

    def game_init
      puts @message.show_message(:game_intro)
      puts @message.show_message(:login)
      @codebreaker_name = gets.chomp
      @game = Game.new(@codebreaker_name)
      puts @message.show_message(:game_start, name: @codebreaker_name)
      launch_game
    end

    def launch_game
      @game.start
      until @game_stop
        answer = gets.chomp
        begin
          raise puts @message.show_message(:failed_input) unless answer_valid?(answer)
          raise puts HMI_CMD.fetch(answer).call(self) if HMI_CMD.keys.include?(answer)
          @game.make_attempt(answer)
          puts @game.game_over? ? show_game_result : show_attempt_result
        rescue
          next
        end
      end
    end

    def answer_valid?(answer)
      @game.valid_attempt?(answer) || HMI_CMD.keys.include?(answer)
    end

    def show_game_result
      puts @message.show_message(:congrats) if @game.won?
      puts @message.show_message(:regrets, secret: @game.secret_code) if @game.lost?
      hmi_cmd_save
      puts @message.show_message(:offer_new_game)
    end

    def show_attempt_result
      @message.show_message(:attempt_result_msg,
                            attempt_result: @game.attempt_result,
                            attempts_remain: @game.attempts_remain,
                            hints_remain: @game.hints_count)
    end

    def hmi_cmd_hint
      return @message.show_message(:no_hint) if @game.hints_count.zero?
      @message.show_message(:hint,
                            hint: @game.hint,
                            hints_count: @game.hints_count)
    end

    def hmi_cmd_save
      @game.save_result
      @message.show_message(:saved)
    end

    def hmi_cmd_help
      @message.show_message(:help)
    end

    def hmi_cmd_replay
      @game = Game.new(@codebreaker_name)
      system('clear')
      puts @message.show_message(:replay)
      launch_game
    end

    def hmi_cmd_exit
      @game_stop = true
      @message.show_message(:game_stop)
    end

    def hmi_cmd_show_score
      result = @game.load_game_score
      @message.show_message(:show_score, score: result)
    end

    def hmi_cmd_show_scores
      result = @game.load_game_score
      @message.show_message(:show_scores, score: result)
    end

    def hmi_cmd_erase_scores
      @game.erase_game_score
      @message.show_message(:erase_score)
    end
  end
end

module Codebreaker
  class Hmi
    def initialize
      @game_stop = false
      @hmi_commands = %w[help hint save replay exit show_score erase_score]
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
          raise puts send(('hmi_cmd_' + answer.downcase).to_sym) if @hmi_commands.include?(answer)
          @game.make_attempt(answer)
          puts @game.game_over? ? show_game_result : show_attempt_result
        rescue
          next
        end
      end
    end

    def answer_valid?(answer)
      @game.valid_attempt?(answer) || @hmi_commands.include?(answer)
    end

    def show_game_result
      puts @message.show_message(:congrats) if @game.won?
      puts @message.show_message(:regrets, secret: @game.secret) if @game.lost?
      hmi_cmd_save
      hmi_cmd_exit
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

    def hmi_cmd_erase_score
      @game.erase_game_score
      @message.show_message(:erase_score)
    end
  end
end

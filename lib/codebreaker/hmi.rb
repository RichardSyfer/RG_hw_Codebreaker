module Codebreaker
  class Hmi
    def initialize
      @game = Game.new
      @message = GameAppMessages.new
    end

    def game_init
      puts @message.show_message(:game_intro)
      puts @message.show_message(:login)
      @codebreaker_name = gets.chomp
      puts @message.show_message(:game_start)
      @game.start
    end

    def launch_game
      game_init

      until @game.game_over?
        answ = gets.chomp
        if answ =~ /^[1-6]{4}$/
          @game.code_check(answ)
          show_attempt_result
        elsif answ =~ /^[Hh]{1}$/
          show_hint
        elsif answ =~ /^[Qq]{1}$/
          return
        else
          p 'Incorrect input'
        end
      end
      p @game.win? ? 'Superb game! You won' : "Sorry, but you, code was #{@game.secret}"
      save_offer
      replay_offer
    end

    # private

    def show_hint
      return @message.show_message(:no_hint) unless @game.hints_count.zero?
      return @message.show_message(:no_need_hint) unless @game.hint.nil?
      @message.show_message(:hint,
                            hint: @game.show_hint,
                            hints_count: @game.hints_count)
    end

    def show_attempt_result
      @message.show_message(:attempt_result,
                            attempt_result: @game.attempt_result,
                            attempts_remain: @game.attempts_remain)
    end

    def save_offer
      p 'Would you like save result'
      @game.save_result if gets.chomp =~ /^[Yy]{1}$/
    end

    def replay_offer
      p 'Would you like play again?'
      if gets.chomp =~ /^[Yy]{1}$/
        @game = Game.new
        system('clear')
        launch_game
      end
    end
  end
end

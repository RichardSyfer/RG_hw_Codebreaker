module Codebreaker
  class Hmi
    def initialize
      @game = Game.new
    end

    def launch_game
      greeting
      @game.start
      until @game.game_over?
        answ = gets.chomp
        if answ =~ /^[1-6]{4}$/
          @game.code_check(answ)
          @game.show_attempt_result
        elsif answ =~ /^[Hh]{1}$/
          @game.hints
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

    private

    def greeting
      p 'Welcome to Codebreaker!'
      p 'Lets try break the code'
      p 'Enter suggested code OR "h" for hint, "q" for exit'
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

module Codebreaker
  class GameAppMessages
    def game_intro
      intro = <<~INTRO
        ____________________CODEBREAKER_________________________
        Codebreaker is a logic game in which a code-breaker
        tries to break a secret code created by a code-maker.
        The code-maker, which will be played by the application,
        creates a secret code of four numbers between 1 and 6.
        ________________________________________________________
      INTRO
      puts intro
    end
  end
end

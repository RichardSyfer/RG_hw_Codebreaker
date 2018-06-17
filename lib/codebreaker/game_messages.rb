module Codebreaker
  class GameAppMessages
    def show_message(method, data = nil)
      send(method, data)
    end

    def game_intro
      <<~INTRO
        ____________________CODEBREAKER_________________________
        Welcome to Codebreaker!
        Codebreaker is a logic game in which a code-breaker
        tries to break a secret code created by a code-maker.
        The code-maker, which will be played by the application,
        creates a secret code of four numbers between 1 and 6.
        ________________________________________________________
      INTRO
    end

    def login
      <<~LOGIN
        Before we begin, please
        Input your name:
      LOGIN
    end

    def game_start
      <<~GAME_START
        Sooo...
        Lets try break the code
        Enter suggested code OR "h" for hint, "q" for exit
        ________________________________________________________
      GAME_START
    end

    def attempt_result(data)
      <<~RES
        Attempt result: #{data[:attempt_result]}
        Remaining attempts: #{data[:attempts_remain]}
      RES
    end

    def no_hint
      'No hints remains'
    end

    def no_need_hint
      'You guessed all numbers, try swap them'
    end

    def hint(data)
      "HINT: #{data[:hint]}, #{data[:hints_count]} hints remains"
    end
  end
end

# puts Codebreaker::GameAppMessages.new.attempt_result(attempt_result: '+--', attempts_remain: 3)
# p Codebreaker::GameAppMessages.new.hint(hint: '++--', hints_count: 3)

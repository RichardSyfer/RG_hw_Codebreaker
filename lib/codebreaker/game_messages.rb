module Codebreaker
  class GameAppMessages
    def show_message(method, data = nil)
      return send(method) if data.nil?
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

    def game_start(data)
      <<~GAME_START
        ________________________________________________________

        Are you ready #{data[:name]} ?
        Lets try break the code
        ________________________________________________________

        Enter suggested code OR "hint"
        "help" to show more options
        ________________________________________________________
      GAME_START
    end

    def help
      <<~HELP
        ________________________________________________________

        help - shows commands list
        hint - shows code hint
        save - save score
        show_score - shows old game scores
        erase_score - erase game scores
        replay - relaunching game
        exit - terminating game
        ________________________________________________________
      HELP
    end

    def failed_input
      'Incorrect input'
    end

    def attempt_result_msg(data)
      <<~RES
        Attempt result: #{data[:attempt_result]}
        Remaining attempts: #{data[:attempts_remain]}
        Hints remain: #{data[:hints_remain]}
      RES
    end

    def congrats
      'Superb game! You won'
    end

    def regrets(data)
      "Sorry, but you lost, code was #{data[:secret]}"
    end

    def no_hint
      'No hints remains'
    end

    def hint(data)
      "HINT: #{data[:hint]}, #{data[:hints_count]} hints remains"
    end

    def replay
      '_____________________GAME_RESTARTED_____________________'
    end

    def saved
      '___________________GAME_RESULT_SAVED____________________'
    end

    def game_stop
      '________________CODEBREAKER_TERMINATED__________________'
    end

    def erase_score
      'Score info deleted'
    end

    def show_score(data)
      return 'No saved score' if data[:score].empty?
      score = ''
      data[:score].each { |k, v| score += "#{k}: #{v} \n" }
        "\n___________________CODEBREAKER_SCORE____________________\n\n" +
        score +
        "________________________________________________________\n"
    end
  end
end

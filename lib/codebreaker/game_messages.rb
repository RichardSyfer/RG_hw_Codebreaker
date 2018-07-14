module Codebreaker
  class GameAppMessages
    def show_message(method, data = nil)
      data ? send(method, data) : send(method)
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
        _______________HMI_COMMANDS_DESCRIPTIONS________________

        help - shows commands list
        hint - shows code hint
        save - save score
        show_score - shows last game score
        show_scores - shows old game scores
        erase_scores - erase game scores
        replay - relaunching game
        exit - terminating game
        ________________________________________________________
      HELP
    end

    def failed_input
      '_________________ERROR:_INCORRECT_INPUT_________________'
    end

    def attempt_result_msg(data)
      <<~RES
        Attempt result: #{data[:attempt_result]}
        Remaining attempts: #{data[:attempts_remain]}
        Hints remain: #{data[:hints_remain]}
      RES
    end

    def congrats
      '________________SUPERB_GAME!_YOU_WON____________________'
    end

    def regrets(data)
      "______SORRY,_BUT_YOU_LOST._CODE_WAS_\"#{data[:secret]}\"_______"
    end

    def offer_new_game
      <<~OFFER
        Enter "replay" if you want start new game,
        Enter "show_score" to see game scores,
        Enter "exit" to terminate game
      OFFER
    end

    def no_hint
      '___________________NO_HINTS_REMAINS_____________________'
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
      '___________________SCORE_INFO_DELETED___________________'
    end

    def show_score(data)
      return '___________________SCORE_LOG_EMPTY___________________' unless data[:score]
      log = ''
      data[:score].last.each do |k, v|
        log += "#{k}: #{v} \n"
      end
      <<~LOG
        \n___________________LAST_GAME_SCORE___________________\n
        #{log}
        _____________________END_OF_SCORE_LOG___________________\n
      LOG
    end

    def show_scores(data)
      return '___________________SCORE_LOG_EMPTY___________________' unless data[:score]
      log = ''
      data[:score].each do |record|
        record.each do |k, v|
          log += "#{k}: #{v} \n"
        end
        log += "----------------------------\n"
      end
      <<~LOG
        \n___________________CODEBREAKER_SCORES___________________\n
        #{log}
        _____________________END_OF_SCORE_LOG___________________\n
      LOG
    end
  end
end

require_relative '../spec_helper'

module Codebreaker
  RSpec.describe Hmi do
    let(:hmi) { Hmi.new }
    hmi_commands = %w[help hint save replay exit show_score erase_score]
    let(:game) { hmi.instance_variable_get(:@game) }
    let(:game_initialization) do
      hmi.instance_variable_set(:@game, Game.new('Test-player: John Doe'))
      game = hmi.instance_variable_get(:@game)
      game.start
    end

    before { game_initialization }

    describe '#launch_game' do
      before { allow(game).to receive(:game_over?).and_return(false, false, true) }
      context 'if user enter wrong hmi command' do
        it 'shows message about wrong input' do
          allow(hmi).to receive(:gets).and_return('qwerty', '1111')
          expect { hmi.launch_game }.to output(/Incorrect/).to_stdout
        end
      end
      context 'if user enter code in wrong format' do
        it 'shows message about wrong input' do
          allow(hmi).to receive(:gets).and_return('0000', '1111')
          expect { hmi.launch_game }.to output(/Incorrect/).to_stdout
        end
      end
      context 'if user enter code' do
        it 'shows message about attempt result' do
          allow(hmi).to receive(:gets).and_return('1234', '1111')
          expect { hmi.launch_game }.to output(/Attempt result:/).to_stdout
        end
      end
      context 'if user enter hmi command [help]' do
        it 'shows message with hmi command result' do
          allow(hmi).to receive(:gets).and_return('help', '1111')
          expect { hmi.launch_game }.to output(/HMI_COMMANDS_DESCRIPTIONS/).to_stdout
        end
      end
    end

    describe '#answer_valid?' do
      context 'if user answer, is valid number: 6523' do
        it 'returns "true"' do
          expect(hmi.answer_valid?('6523')).to be true
        end
      end

      context 'if user answer, is valid hmi command' do
        hmi_commands.each do |cmd|
          it 'command: "' + cmd + '" returns "true"' do
            expect(hmi.answer_valid?(cmd)).to be true
          end
        end
      end

      context 'if user answer, is invalid hmi command or number' do
        it 'returns "false"' do
          expect(hmi.answer_valid?('show')).to be false
          expect(hmi.answer_valid?('7812')).to be false
        end
      end
    end

    describe '#show_game_result' do
      context 'if player won' do
        it 'show congradulations' do
          allow(hmi).to receive(:hmi_cmd_save)
          allow(hmi).to receive(:hmi_cmd_exit)
          allow(game).to receive(:won?).and_return(true)
          expect { hmi.show_game_result }.to output(/Superb game! You won/).to_stdout
        end
      end
      context 'if player lost' do
        it 'show regrets' do
          allow(hmi).to receive(:hmi_cmd_save)
          allow(hmi).to receive(:hmi_cmd_exit)
          allow(game).to receive(:lost?).and_return(true)
          expect { hmi.show_game_result }.to output(/Sorry, but/).to_stdout
        end
      end
    end

    describe '#show_attempt_result' do
      it 'show message about attempt result' do
        expect(hmi.show_attempt_result).to match('Attempt result:')
      end
    end

    describe '#hmi_cmd_hint' do
      context 'if player have hits' do
        it 'returns hint (digit from secret code)' do
          game.instance_variable_set(:@secret_code, '2222')
          expect(hmi.hmi_cmd_hint).to eq 'HINT: 2, 2 hints remains'
        end
      end
    end

    describe '#hmi_cmd_save' do
      it 'returns message "Game saved"' do
        allow(game).to receive(:save_result)
        expect(hmi.hmi_cmd_save).to match(/GAME_RESULT_SAVED/)
      end
    end

    describe '#hmi_cmd_help' do
      it 'returns descriptions of all available hmi hmi_commands' do
        hmi_commands.each do |cmd|
          expect(hmi.hmi_cmd_help).to match(/#{cmd}/)
        end
      end
    end

    describe '#hmi_cmd_replay' do
      before { allow(hmi).to receive(:system).with('clear') }
      it 'returns message "Game restarted"' do
        allow(hmi).to receive(:launch_game)
        expect { hmi.hmi_cmd_replay }.to output(/GAME_RESTARTED/).to_stdout
      end
      it 'creates new game instance' do
        allow(hmi).to receive(:launch_game)
        game_id_before = hmi.instance_variable_get(:@game).__id__
        hmi.hmi_cmd_replay
        game_id_after = hmi.instance_variable_get(:@game).__id__
        expect(game_id_before).not_to eq game_id_after
      end
    end

    describe '#hmi_cmd_exit' do
      it 'returns message "Codebreaker terminated"' do
        expect(hmi.hmi_cmd_exit).to match(/CODEBREAKER_TERMINATED/)
      end
      it 'game stopped' do
        hmi.hmi_cmd_exit
        expect(hmi.instance_variable_get(:@game_stop)).to be true
      end
    end

    describe '#hmi_cmd_show_score' do
      context 'if score log not empty' do
        it 'returns message about saved game score' do
          expect(hmi.hmi_cmd_show_score).to match(/CODEBREAKER_SCORE/)
        end
      end
      context 'if score log is empty' do
        it 'returns message about empty score log' do
          allow(game).to receive(:load_game_score).and_return('')
          expect(hmi.hmi_cmd_show_score).to match(/No saved score/)
        end
      end
    end

    describe '#hmi_cmd_erase_score' do
      it 'returns message about deleted score' do
        allow(game).to receive(:erase_game_score)
        expect(hmi.hmi_cmd_erase_score).to match(/Score info deleted/)
      end
    end
  end
end

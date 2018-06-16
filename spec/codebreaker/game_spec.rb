# frozen_string_literal: true

require_relative '../spec_helper'
module Codebreaker
  RSpec.describe Game do
    include Helper

    let(:game) { Game.new }

    describe '#start' do
      let(:secret_code) { game.instance_variable_get(:@secret_code).join }
      before do
        game.start
      end

      it 'generates and saves secret code with numbers from 1 to 6' do
        expect(secret_code).to match(/^[1-6]{4}$/)
      end
    end

    describe '#code_check' do
      describe 'cheking code algorithm' do
        it 'returns \'++++\' when the secret code is equal entered code' do
          cheking_code_algorithm('1234', '1234')
          expect(game.attempt_result).to eq '++++'
        end

        it 'returns empty string if wrong digits was guessed' do
          cheking_code_algorithm('1234', '5555')
          expect(game.attempt_result).to eq ''
        end

        it 'returns one \'+\' sign if guessed one digit with monotype input - i.e. 5555' do
          cheking_code_algorithm('1235', '5555')
          expect(game.attempt_result).to eq '+'
        end

        it 'returns \'+\' if digit and position was guessed' do
          cheking_code_algorithm('2134', '5634')
          expect(game.attempt_result).to eq '++'
        end

        it 'returns \'-\' if digit was guessed but not a position' do
          cheking_code_algorithm('6345', '4563')
          expect(game.attempt_result).to eq '----'
        end

        it 'returns mix of \'-\' and  \'+\' signs if some guessed digits on right position and other not' do
          cheking_code_algorithm('6345', '6235')
          expect(game.attempt_result).to eq '++-'
        end
      end
    end

    describe '#win?' do
      it 'returns true, if player guessed code' do
        cheking_code_algorithm('1234', '1234')
        expect(game.win?).to be true
      end
    end

    describe '#lost?' do
      it 'returns true, if player no attempts remain' do
        game.instance_variable_set(:@attempts_remain, 0)
        expect(game.lost?).to be true
      end
      it 'returns false, if player have attempts remain' do
        expect(game.lost?).to be false
      end
    end

    describe '#game_over?' do
      it 'returns true, if player won or lost' do
        game.instance_variable_set(:@attempts_remain, 0)
        expect(game.game_over?).to be true

        cheking_code_algorithm('1234', '1234')
        expect(game.game_over?).to be true
      end
    end

    describe '#hints' do
      it 'doesn\'t returns hint if there are no more hints left' do
        game.instance_variable_set(:@hints_count, 0)
        expect { game.hints }.to output(/No hints remains/).to_stdout
      end

      it 'doesn\'t returns hint if player guessed all digits of code' do
        cheking_code_algorithm('1234', '4231')
        expect { game.hints }.to output(/You guessed all numbers/).to_stdout
      end

      it 'returns hint if it possible' do
        cheking_code_algorithm('1234', '4531')
        expect { game.hints }.to output(/HINT: 2/).to_stdout
      end
    end

    describe '#secret' do
      it 'returns secret code' do
        game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
        expect(game.secret).to eq '1234'
      end
    end

    describe '#save_result' do
      let(:player_name) { 'Test_Player_' + rand(1..9999).to_s }

      it 'saves game result' do
        allow(game).to receive(:gets).and_return(player_name)
        game.save_result
        data = File.read('./lib/game_data.yml')
        expect(data).to include(player_name)
      end
    end
  end
end

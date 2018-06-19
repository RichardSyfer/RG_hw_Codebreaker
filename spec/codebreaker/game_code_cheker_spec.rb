require_relative '../spec_helper'
module Codebreaker
  RSpec.describe GameCodeChecker do

    describe '#code_check' do
      describe 'cheking code algorithm' do
        # it 'returns \'++++\' when the secret code is equal entered code' do
        #   cheking_code_algorithm('1234', '1234')
        #   expect(game.attempt_result).to eq '++++'
        # end

        # it 'returns empty string if wrong digits was guessed' do
        #   cheking_code_algorithm('1234', '5555')
        #   expect(game.attempt_result).to eq ''
        # end

        # it 'returns one \'+\' sign if guessed one digit with monotype input - i.e. 5555' do
        #   cheking_code_algorithm('1235', '5555')
        #   expect(game.attempt_result).to eq '+'
        # end

        # it 'returns \'+\' if digit and position was guessed' do
        #   cheking_code_algorithm('2134', '5634')
        #   expect(game.attempt_result).to eq '++'
        # end

        # it 'returns \'-\' if digit was guessed but not a position' do
        #   cheking_code_algorithm('6345', '4563')
        #   expect(game.attempt_result).to eq '----'
        # end

        # it 'returns mix of \'-\' and  \'+\' signs if some guessed digits on right position and other not' do
        #   cheking_code_algorithm('6345', '6235')
        #   expect(game.attempt_result).to eq '++-'
        # end
      end
    end
  end
end
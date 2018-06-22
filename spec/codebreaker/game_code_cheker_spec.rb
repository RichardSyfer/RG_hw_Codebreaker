require_relative '../spec_helper'
module Codebreaker
  RSpec.describe GameCodeChecker do
    describe '#check_result' do
      context 'cheking code algorithm' do
        samples = [
          ['1234', '1234', '++++'],
          ['6543', '6543', '++++'],
          ['6543', '6541', '+++'],
          ['6543', '6512', '++'],
          ['6543', '6122', '+'],
          ['6543', '2222', ''],
          ['6543', '3456', '----'],
          ['6543', '3451', '---'],
          ['6543', '3411', '--'],
          ['6543', '3111', '-'],
          ['3333', '3111', '+'],
          ['3133', '3111', '++'],
          ['3124', '3142', '++--'],
          ['3124', '3412', '+---'],
          ['5124', '3412', '---'],
          ['5124', '3124', '+++'],
          ['5124', '5334', '++'],
          ['5124', '5332', '+-'],
          ['5124', '4125', '++--'],
          ['5124', '5214', '++--'],
          ['5124', '2541', '----'],
          ['5124', '6416', '--'],
          ['5124', '4533', '--'],
          ['1534', '5312', '---'],
          ['1534', '5436', '+--'],
          ['1534', '2514', '++-'],
          ['1534', '6223', '-'],
          ['1534', '2564', '++'],
          ['1534', '6664', '+'],
          ['1534', '1111', '+'],
          ['1534', '3333', '+']
        ]

        samples.each do |sample|
          it 'on secret:"' + sample[0] +
            '" with guess: "' + sample[1] +
            '" returns: "' + sample[2] do
              checker = GameCodeChecker.new(sample[0], sample[1])
              expect(checker.check_result).to eq sample[2]
            end
          end
      end
    end

    describe '#exact_matches' do
      let(:checker) { GameCodeChecker.new('5621', '5341') }
      it 'returns "+", on place with exact matches' do
        expect(checker.exact_matches).to eq ['+', nil, nil, '+']
      end

      it 'method delete numbers with exact positions from secret and guess' do
        checker.exact_matches
        expect(checker.instance_variable_get(:@secret)).to eq [nil, '6', '2', nil]
        expect(checker.instance_variable_get(:@breaker_code)).to eq [nil, '3', '4', nil]
      end
    end

    describe '#matches' do
      context 'if secret code and guess have same numbers on different positions' do
        it 'returns "-"' do
          checker = GameCodeChecker.new('6512', '5341')
          expect(checker.matches).to eq ['-', '-']
        end
      end
    end
  end
end

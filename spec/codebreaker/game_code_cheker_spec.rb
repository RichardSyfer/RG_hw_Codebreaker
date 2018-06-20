require_relative '../spec_helper'
module Codebreaker
  RSpec.describe GameCodeChecker do
    describe '#code_check' do
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
  end
end

require_relative '../spec_helper'

module Codebreaker
  RSpec.describe Game do
    describe '#start' do
      before(:all) do
        @game = Game.new
        @game.start
        @secret_code = @game.instance_variable_get(:@secret_code)
      end
      it 'generates secret code' do
        expect(@secret_code).not_to be_empty
      end
      it 'saves 4 numbers secret code' do
        expect(@secret_code.length).to eq 4
      end
      it 'saves secret code with numbers from 1 to 6' do
        expect(@secret_code).to match(/[1-6]+/)
      end
    end
  end
end

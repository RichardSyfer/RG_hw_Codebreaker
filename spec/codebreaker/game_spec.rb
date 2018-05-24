require_relative '../spec_helper'

module Codebreaker
  RSpec.describe Game do
    describe '#start' do
      before(:all) do
        @game = Game.new
        @game.start
        @secret_code = @game.instance_variable_get(:@secret_code)
      end
      it 'generates and saves secret code with numbers from 1 to 6' do
        expect(@secret_code).to match(/^[1-6]{4}$/)
      end
    end
  end
end

require_relative '../spec_helper'

module Codebreaker
  RSpec.describe Hmi do
    let(:hmi) { Hmi.new }
    let(:game) { hmi.instance_variable_get(:@game) }

    describe '#launch_game' do
      describe 'call Game.methods' do
        it '#code_check' do
          allow(hmi).to receive(:gets).and_return('1234')
          # expect(game).to receive(:code_check)
          # hmi.launch_game
        end

        it '#hints'
        it '#save_result'
      end
    end

  end
end

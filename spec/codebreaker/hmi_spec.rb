require_relative '../spec_helper'

module Codebreaker
  RSpec.describe Hmi do
    let(:hmi) { Hmi.new }
    let(:game) { hmi.instance_variable_get(:@game) }

    describe '#launch_game' do
      before do
        allow(hmi).to receive(:gets).and_return('1234')
      end
      it 'print greeting' do
        string =<<-STR
        Welcome to Codebreaker!
        Lets try break the code
        Enter suggested code OR "h" for hint, "q" for exit
        STR
        expect(hmi).to receive(:greeting).and_return(string)
        hmi.launch_game
      end

      it '#show_hint' do
        # allow(hmi).to receive(:gets).and_return('1234', 'h')
        expect(hmi).to receive(:show_hint).and_return(5)
        hmi.show_hint
      end
    end

  end
end

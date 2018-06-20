require_relative '../spec_helper'

module Codebreaker
  RSpec.describe Hmi do
    let(:hmi) { Hmi.new }
    let(:game) { hmi.instance_variable_get(:@game) }
    let(:game_initialization) do
      hmi.instance_variable_set(:@game, Game.new('John Doe'))
      @game = hmi.instance_variable_get(:@game)
      @game.start
    end

    before { game_initialization }

    describe '#answer_valid?' do
      context 'if user answer, is valid number: 6523' do
        it 'returns "true"' do
          expect(hmi.answer_valid?('6523')).to be true
        end
      end

      context 'if user answer, is valid hmi command' do
        # let(:commands) { hmi.instance_variable_get(:@hmi_commands) }
        commands = %w[help hint save replay exit show_score erase_score]
        commands.each do |cmd|
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

    describe '#hmi_cmd_hint' do
      context 'if player have hits' do
        it 'returns hint (digit from secret code)' do
          game.instance_variable_set(:@secret_code, '2222')
          expect(hmi.hmi_cmd_hint).to eq 'HINT: 2, 2 hints remains'
        end
      end
    end
  end
end

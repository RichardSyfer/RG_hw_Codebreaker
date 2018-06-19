# frozen_string_literal: true
require 'yaml'
require_relative '../spec_helper'
module Codebreaker
  RSpec.describe Game do
    include Helper

    let(:game) { Game.new('John Doe') }

    describe '#start' do
      let(:secret_code) { game.instance_variable_get(:@secret_code) }
      before do
        game.start
      end

      it 'generates and saves secret code with numbers from 1 to 6' do
        expect(secret_code).to match(/^[1-6]{4}$/)
      end
    end

    describe '#won?' do
      it 'returns true, if player guessed code' do
        game.instance_variable_set(:@attempt_result, '++++')
        expect(game.won?).to be true
      end
      it 'returns false, if player no attempts remain' do
        game.instance_variable_set(:@attempts_remain, 0)
        expect(game.won?).to be false
      end
      it 'returns false, if player lost' do
        allow(game).to receive(:lost?).and_return(true)
        expect(game.won?).to be false
      end
    end

    describe '#lost?' do
      it 'returns true, if player no attempts remain' do
        game.instance_variable_set(:@attempts_remain, 0)
        expect(game.lost?).to be true
      end
      it 'returns false, if player have attempts remain' do
        game.instance_variable_set(:@attempts_remain, 1)
        expect(game.lost?).to be false
      end
      it 'returns false, if player won' do
        allow(game).to receive(:won?).and_return(true)
        expect(game.lost?).to be false
      end
    end

    describe '#game_over?' do
      it 'returns true, if player won' do
        allow(game).to receive(:won?).and_return(true)
        expect(game.game_over?).to be true
      end

      it 'returns true, if player lost' do
        allow(game).to receive(:lost?).and_return(true)
        expect(game.game_over?).to be true
      end
    end

    describe '#game_state' do
      it 'returns "pending", if game not over' do
        allow(game).to receive(:game_over?).and_return(false)
        expect(game.game_state).to eq 'pending'
      end

      it 'returns "won", if player won' do
        allow(game).to receive(:won?).and_return(true)
        expect(game.game_state).to eq 'won'
      end

      it 'returns "lost", if player lost' do
        allow(game).to receive(:lost?).and_return(true)
        expect(game.game_state).to eq 'lost'
      end
    end

    describe '#valid_attempt?' do
      it 'returns true, if player guess-code valid: "6543"' do
        expect(game.valid_attempt?('6543')).to be true
      end
      it 'returns false, if player guess-code invalid: "0123"' do
        expect(game.valid_attempt?('0123')).to be false
      end
      it 'returns false, if player guess-code invalid: "12345"' do
        expect(game.valid_attempt?('12345')).to be false
      end
      it 'returns false, if player guess-code invalid: "7123"' do
        expect(game.valid_attempt?('7123')).to be false
      end
    end

     describe '#hint' do
      it 'doesn\'t returns hint if there are no more hints left' do
        game.instance_variable_set(:@hints_count, 0)
        expect(game.hint).to eq nil
      end

      it 'returns hint if it possible' do
        game.instance_variable_set(:@secret_code, '1234')
        expect(game.hint).to match(/^[1234]{1}$/)
      end
    end

    describe '#secret' do
      it 'returns secret code' do
        game.instance_variable_set(:@secret_code, '1234')
        expect(game.secret).to eq '1234'
      end
    end

    describe '#save_result' do
      it 'saves game result' do
        game.instance_variable_set(:@secret_code, '1234')
        game.instance_variable_set(:@attempt_result, '++++')
        game.save_result
        saved_result = YAML.load(File.open(game.instance_variable_get(:@game_data_file_path), 'r'))
        expect(saved_result).to eq(saved_result)
      end
    end
  end
end

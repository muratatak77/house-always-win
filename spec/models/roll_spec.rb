# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Roll, type: :model do
  describe 'associations' do
    it 'belongs to game_session' do
      assoc = described_class.reflect_on_association(:game_session)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with 3 symbols and positive reward' do
      gs = create(:game_session, status: :open)
      roll = described_class.new(
        game_session: gs,
        symbols: %w[C C C],
        reward: 10,
        win: true,
        cheated: false
      )
      expect(roll).to be_valid
    end

    it 'requires symbols presence' do
      r = build(:roll, symbols: nil)
      expect(r).not_to be_valid
      expect(r.errors[:symbols]).to be_present
    end

    it 'requires reward >= 0' do
      r = build(:roll, reward: -1)
      expect(r).not_to be_valid
      expect(r.errors[:reward]).to be_present
    end

    it 'requires game_session' do
      r = build(:roll, game_session: nil)
      expect(r).not_to be_valid
    end
  end

  describe 'lifecycle' do
    it 'is destroyed when its game_session destroyed (cascade from parent)' do
      gs = create(:game_session, status: :open)
      create_list(:roll, 2, game_session: gs)

      expect { gs.destroy }.to change(described_class, :count).by(-2)
    end
  end
end

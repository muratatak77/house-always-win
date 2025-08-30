require 'rails_helper'

RSpec.describe CashOut, type: :model do
  describe "associations" do
    it "belongs to player" do
      assoc = described_class.reflect_on_association(:player)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "belongs to game_session" do
      assoc = described_class.reflect_on_association(:game_session)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    it "is valid with player, session, amount >= 0" do
      gs = create(:game_session, status: :open)
      co = described_class.new(player: gs.player, game_session: gs, amount: 7)
      expect(co).to be_valid
    end

    it "rejects negative amount" do
      gs = create(:game_session, status: :open)
      co = described_class.new(player: gs.player, game_session: gs, amount: -1)
      expect(co).not_to be_valid
      expect(co.errors[:amount]).to be_present
    end

    it "requires player " do
      gs = create(:game_session, status: :open)
      co = described_class.new(player: nil, game_session: gs, amount: 5)
      expect(co).not_to be_valid
      expect(co.errors[:player]).to be_present
    end

    it "requires game_session" do
      p = create(:player)
      co = described_class.new(player: p, game_session: nil, amount: 5)
      expect(co).not_to be_valid
      expect(co.errors[:game_session]).to be_present
    end
  end
end

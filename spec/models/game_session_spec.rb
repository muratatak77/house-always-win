require 'rails_helper'

RSpec.describe GameSession, type: :model do
  describe "validations" do
    it "defaults to 10 credits and open" do
      gs = build(:game_session)
      expect(gs.credits).to eq(10)
      expect(gs).to be_open
    end

    it "is invalid with negative credits" do
      gs = build(:game_session, credits: -1)
      expect(gs).not_to be_valid
    end

    it "fixes nil credits to 10 before validation" do
      gs = GameSession.new(player: create(:player), status: :open, credits: nil)
      gs.valid?
      expect(gs.credits).to eq(10)
    end
  end


  describe "associations" do
    it "belongs to player" do
      assoc = described_class.reflect_on_association(:player)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "has many rolls (destroy on session destroy)" do
      assoc = described_class.reflect_on_association(:rolls)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end
  end

  describe "dependent destroy" do
    it "destroys rolls when session destroyed" do
      gs = create(:game_session, status: :open)
      create_list(:roll, 3, game_session: gs)

      expect { gs.destroy }.to change { Roll.count }.by(-3)
    end
  end
end

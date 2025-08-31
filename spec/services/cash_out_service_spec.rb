require "rails_helper"

RSpec.describe CashOutService do
  describe ".call" do
    it "moves credits to player and close session" do
      gs = create(:game_session, status: :open, credits: 17)
      player = gs.player

      res = described_class.call(session: gs)

      # response shape
      expect(res[:moved]).to eq(true)
      expect(res[:amount]).to eq(17)
      expect(res[:account_credits]).to eq(player.reload.account_credits)

      # db states after
      gs.reload
      expect(gs.status).to eq("closed")
      expect(gs.credits).to eq(0)
      expect(player.account_credits).to eq(17)

      # audit row created
      co = CashOut.order(:id).last
      expect(co.player_id).to eq(player.id)
      expect(co.game_session_id).to eq(gs.id)
      expect(co.amount).to eq(17)
    end

    it "raises AlreadyCashedOutError when cash_out exists for same session" do
      gs = create(:game_session, status: :open, credits: 9)
      create(:cash_out, player: gs.player, game_session: gs, amount: 9)

      expect {
        described_class.call(session: gs)
      }.to raise_error(CashOutService::AlreadyCashedOutError)
    end

    it "raises SessionClosedError when session closed" do
      gs = create(:game_session, status: :closed, credits: 10)

      expect {
        described_class.call(session: gs)
      }.to raise_error(CashOutService::SessionClosedError)
    end

    it "raises NoCreditsError when credits is zero" do
      gs = create(:game_session, status: :open, credits: 0)

      expect {
        described_class.call(session: gs)
      }.to raise_error(CashOutService::NoCreditsError)
    end
  end
end

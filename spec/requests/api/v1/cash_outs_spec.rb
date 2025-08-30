# spec/requests/api/v1/cash_outs_spec.rb
require "rails_helper"

RSpec.describe "API::V1::CashOuts", type: :request do
  describe "POST /api/v1/cash_outs" do
    it "returns cash out json (200) when service ok" do
      gs = create(:game_session, status: :open, credits: 15)

      # stub service: fixed payload
      expect(CashOutService)
        .to receive(:call)
        .with(session: gs)
        .and_return({ moved: true, amount: 15, account_credits: 42 })

      post "/api/v1/cash_outs", params: { game_session_id: gs.id }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to include(
        "moved" => true,
        "amount" => 15,
        "account_credits" => 42
      )
    end

    it "404 when session not found" do
      post "/api/v1/cash_outs", params: { game_session_id: 999_999 }
      expect(response).to have_http_status(:not_found)
      body = JSON.parse(response.body)
      expect(body["error"]).to eq("session_not_found")
    end
  end
end

# frozen_string_literal: true

# spec/requests/api/v1/rolls_spec.rb
require 'rails_helper'

RSpec.describe 'API::V1::Rolls', type: :request do
  describe 'POST /api/v1/rolls' do
    it 'returns roll json (200) when service ok' do
      gs = create(:game_session, status: :open, credits: 10)

      expect(SlotMachineService)
        .to receive(:call)
        .with(session: gs)
        .and_return({symbols: %w[C C C], win: true, reward: 10, cheated: false, credits: 20})

      post '/api/v1/rolls', params: {game_session_id: gs.id}

      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body).to include(
        'symbols' => %w[C C C],
        'win' => true,
        'reward' => 10,
        'cheated' => false,
        'credits' => 20
      )
    end

    it '404 when session not found' do
      post '/api/v1/rolls', params: {game_session_id: 999_999}
      expect(response).to have_http_status(:not_found)
      body = response.parsed_body
      expect(body['error']).to eq('session_not_found')
    end

    it '422 when service says session closed' do
      gs = create(:game_session, status: :closed, credits: 10)

      expect(SlotMachineService)
        .to receive(:call)
        .with(session: gs)
        .and_raise(SlotMachineService::SessionClosedError)

      post '/api/v1/rolls', params: {game_session_id: gs.id}

      expect(response).to have_http_status(:unprocessable_entity)
      body = response.parsed_body
      expect(body['error']).to eq('session_closed')
    end

    it '422 when service says no credits' do
      gs = create(:game_session, status: :open, credits: 0)

      expect(SlotMachineService)
        .to receive(:call)
        .with(session: gs)
        .and_raise(SlotMachineService::NoCreditsError)

      post '/api/v1/rolls', params: {game_session_id: gs.id}

      expect(response).to have_http_status(:unprocessable_entity)
      body = response.parsed_body
      expect(body['error']).to eq('no_credits')
    end
  end
end

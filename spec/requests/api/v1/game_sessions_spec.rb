# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V1::GameSessions', type: :request do
  describe 'POST /api/v1/game_sessions' do
    it 'creates a new open session when none exists' do
      player = create(:player)

      post '/api/v1/game_sessions', params: {player_id: player.id}

      expect(response).to have_http_status(:created)
      body = response.parsed_body
      expect(body['player_id']).to eq(player.id)
      expect(body['status']).to eq('open')
      expect(body['credits']).to be >= 0
    end

    it 'returns existing open session if already exists' do
      player = create(:player)
      existing = create(:game_session, player: player, status: :open, credits: 10)

      post '/api/v1/game_sessions', params: {player_id: player.id}

      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body['id']).to eq(existing.id)
      expect(body['status']).to eq('open')
    end

    it '404 if player not found' do
      post '/api/v1/game_sessions', params: {player_id: 999_999}
      expect(response).to have_http_status(:not_found).or have_http_status(:bad_request)
    end
  end

  describe 'GET /api/v1/game_sessions/:id' do
    it 'returns the session json' do
      gs = create(:game_session, status: :open, credits: 10)

      get "/api/v1/game_sessions/#{gs.id}"

      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body['id']).to eq(gs.id)
      expect(body['credits']).to eq(10)
      expect(body['status']).to eq('open')
    end

    it '404 when not exist' do
      get '/api/v1/game_sessions/999999'
      expect(response).to have_http_status(:not_found)
    end
  end
end

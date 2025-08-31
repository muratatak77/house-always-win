# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V1::GameSessions', type: :request do
  describe 'POST /api/v1/game_sessions' do
    it 'creates a new player and open session when no session present' do
      expect do
        post '/api/v1/game_sessions'
      end.to change(Player, :count).by(1)
                                   .and change(GameSession, :count).by(1)

      expect(response).to have_http_status(:created)
      body = response.parsed_body
      expect(body['status']).to eq('open')
      expect(body['credits']).to be >= 0
      expect(body['player_id']).to be_present
    end

    it 'returns remembered open session when browser session has game_session_id' do
      # first create a session and capture the cookie
      post '/api/v1/game_sessions'
      cookie = response.headers['Set-Cookie']
      body1 = response.parsed_body

      # second request with same cookie should return the same open session
      post '/api/v1/game_sessions', headers: {'Cookie' => cookie}

      expect(response).to have_http_status(:ok)
      body2 = response.parsed_body
      expect(body2['id']).to eq(body1['id'])
      expect(body2['status']).to eq('open')
    end

    it 'reuses open session for remembered player_id from browser session' do
      # create a player + open session manually
      player = create(:player)
      gs     = create(:game_session, player:, status: :open, credits: 7)

      # simulate browser having that session remembered by setting cookie once
      post '/api/v1/game_sessions', params: {player_id: player.id}
      cookie = response.headers['Set-Cookie']

      # second request with same cookie should reuse existing open session
      post '/api/v1/game_sessions', headers: {'Cookie' => cookie}

      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body['id']).to eq(gs.id)
      expect(body['player_id']).to eq(player.id)
      expect(body['status']).to eq('open')
    end

    it 'creates a new open session for remembered player when no open exists' do
      player = create(:player)

      # hit endpoint once to store player_id in session
      post '/api/v1/game_sessions', params: {player_id: player.id}
      cookie = response.headers['Set-Cookie']

      # close any existing sessions for that player
      GameSession.where(player:).update_all(status: :closed)

      expect do
        post '/api/v1/game_sessions', headers: {'Cookie' => cookie}
      end.to change(GameSession, :count).by(1)

      expect(response).to have_http_status(:created)
      body = response.parsed_body
      expect(body['player_id']).to eq(player.id)
      expect(body['status']).to eq('open')
    end

    it 'supports explicit player_id param (legacy) and reuses existing open session' do
      player = create(:player)
      gs     = create(:game_session, player:, status: :open, credits: 10)

      post '/api/v1/game_sessions', params: {player_id: player.id}

      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body['id']).to eq(gs.id)
      expect(body['status']).to eq('open')
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

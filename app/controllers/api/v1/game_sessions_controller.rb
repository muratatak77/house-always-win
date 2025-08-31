# frozen_string_literal: true

module Api
  module V1
    class GameSessionsController < Api::BaseApiController
      # GET /api/v1/game_sessions/:id
      def show
        game_session = GameSession.find(params[:id])
        render json: present(game_session), status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: {error: 'not_found'}, status: :not_found
      end

      # POST /api/v1/game_sessions
      # create or return an open session bound to this browser
      def create
        if (remembered = find_remembered_open_session)
          return render json: present(remembered), status: :ok
        end

        player = find_player_from_cookie_or_param || build_new_player

        if (open = find_open_session_for(player))
          remember!(player: player, session: open)
          return render json: present(open), status: :ok
        end

        session = create_open_session_for(player)
        remember!(player: player, session: session)
        render json: present(session), status: :created
      rescue ActiveRecord::RecordNotUnique
        # race: another request created it, fetch and return
        open = find_open_session_for(player)
        remember!(player: player, session: open) if open
        render json: present(open), status: :ok
      end

      private

      # if browser already remembers an open session, use it
      def find_remembered_open_session
        return nil if session[:game_session_id].blank?

        gs = GameSession.find_by(id: session[:game_session_id])
        return gs if gs&.status == 'open'

        nil
      end

      # find player from cookie or param, or build a new one
      def find_player_from_cookie_or_param
        if session[:player_id].present?
          p = Player.find_by(id: session[:player_id])
          return p if p
        end

        return Player.find_by(id: params[:player_id]) if params[:player_id].present?

        nil
      end

      # returns Player (new, unsaved yet saved when created)
      def build_new_player
        Player.create!(account_credits: 0)
      end

      # if player already has an open session (race or multi-tab), reuse it
      def find_open_session_for(player)
        player.game_sessions.find_by(status: :open)
      end

      def create_open_session_for(player)
        player.game_sessions.create!(status: :open)
      end

      def remember!(player:, session:)
        self.session[:player_id] = player.id
        self.session[:game_session_id] = session.id
      end

      def present(game_session)
        {
          id: game_session.id,
          player_id: game_session.player_id,
          credits: game_session.credits,
          status: game_session.status,
          last_roll_at: game_session.last_roll_at
        }
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class GameSessionsController < Api::BaseApiController
      include Presentable

      # GET /api/v1/game_sessions/:id
      def show
        game_session = GameSession.find(params[:id])
        render json: present(game_session), status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: {error: 'not_found'}, status: :not_found
      end

      # POST /api/v1/game_sessions
      def create
        result = GameSessionService.call(browser_session: session, params: params)
        render json: present(result.game_session), status: result.status
      end

      private

      def self.presenter_class
        Api::V1::GameSessionPresenter
      end
    end
  end
end

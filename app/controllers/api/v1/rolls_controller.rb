# frozen_string_literal: true

module Api
  module V1
    class RollsController < Api::BaseApiController
      include Presentable

      rescue_from SlotMachineService::SessionClosedError, with: :render_session_closed
      rescue_from SlotMachineService::NoCreditsError, with: :render_no_credits

      def create
        session = GameSession.find(params.require(:game_session_id))
        result  = SlotMachineService.call(session: session)

        render json: present(result), status: :ok
      end

      private

      def present(result)
        Api::V1::RollResultPresenter.new(result).as_json
      end

      # tell base which 404 code to use
      def not_found_code
        'session_not_found'
      end

      def render_session_closed(_e)
        render_error('session_closed', :unprocessable_content)
      end

      def render_no_credits(_e)
        render_error('no_credits', :unprocessable_content)
      end
    end
  end
end

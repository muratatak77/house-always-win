# frozen_string_literal: true
module Api
  module V1
    class CashOutsController < Api::BaseApiController
      include Presentable

      def create
        session = GameSession.find(params.require(:game_session_id))
        result  = CashOutService.call(session: session)

        render json: present(result), status: :ok
      end

      private
      def present(result)
        Api::V1::CashOutResultPresenter.new(result).as_json
      end

      def not_found_code
        'session_not_found'
      end
    end
  end
end

# frozen_string_literal: true

# app/controllers/api/v1/cash_outs_controller.rb
module Api
  module V1
    class CashOutsController < Api::BaseApiController
      def create
        session = GameSession.find(params.require(:game_session_id))
        result  = CashOutService.call(session: session)

        render json: cash_out_payload(result), status: :ok
      end

      private

      # pick fields for response
      def cash_out_payload(res)
        {
          moved: res[:moved],
          amount: res[:amount],
          account_credits: res[:account_credits]
        }
      end

      def not_found_code
        'session_not_found'
      end
    end
  end
end

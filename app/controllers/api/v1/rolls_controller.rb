# app/controllers/api/v1/rolls_controller.rb
module Api
  module V1
    class RollsController < Api::BaseApiController
      rescue_from SlotMachineService::SessionClosedError, with: :render_session_closed
      rescue_from SlotMachineService::NoCreditsError, with: :render_no_credits

      def create
        session = GameSession.find(params.require(:game_session_id))
        result  = SlotMachineService.call(session: session)

        # build payload one place
        render json: roll_payload(result), status: :ok
      end

      private

      def roll_payload(res)
        {
          symbols: res[:symbols],
          win:     res[:win],
          reward:  res[:reward],
          cheated: res[:cheated],
          credits: res[:credits]
        }
      end

      # tell base which 404 code to use
      def not_found_code
        "session_not_found"
      end

      def render_session_closed(_e)
        render_error("session_closed", :unprocessable_content)
      end

      def render_no_credits(_e)
        render_error("no_credits", :unprocessable_content)
      end
    end
  end
end

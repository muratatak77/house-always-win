module Api
  module V1
    class GameSessionPresenter < BasePresenter
      def as_json
        {
          id: object.id,
          player_id: object.player_id,
          credits: object.credits,
          status: object.status,
          last_roll_at: object.last_roll_at
        }
      end
    end
  end
end
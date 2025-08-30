module Api
  module V1
    class GameSessionsController < Api::BaseApiController
      # create new open session for player
      # if open session already exist, return it
      def create
        player = Player.find(params.require(:player_id))

        gs = player.game_sessions.find_by(status: :open)
        if gs
          return render json: present(gs), status: :ok
        end

        # make new open session
        begin
          gs = player.game_sessions.create!(status: :open)
          render json: present(gs), status: :created
        rescue ActiveRecord::RecordNotUnique
          # race: other request created it. fetch and return
          gs = player.game_sessions.find_by!(status: :open)
          render json: present(gs), status: :ok
        end
      end

      # show a session
      def show
        gs = GameSession.find(params[:id])
        render json: present(gs), status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "not_found" }, status: :not_found
      end

      private

      # small presenter
      def present(gs)
        {
          id: gs.id,
          player_id: gs.player_id,
          credits: gs.credits,
          status: gs.status,
          last_roll_at: gs.last_roll_at
        }
      end
    end
  end
end

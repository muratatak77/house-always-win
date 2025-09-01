module Api
  module V1
    class RollResultPresenter < BasePresenter
      def as_json
        {
          symbols: object[:symbols],
          win: object[:win],
          reward: object[:reward],
          cheated: object[:cheated],
          credits: object[:credits]
        }
      end
    end
  end
end
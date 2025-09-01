module Api
  module V1
    class CashOutResultPresenter < BasePresenter
      def as_json
        {
          moved: object[:moved],
          amount: object[:amount],
          account_credits: object[:account_credits]
        }
      end
    end
  end
end
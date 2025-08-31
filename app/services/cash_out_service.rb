# frozen_string_literal: true

# move credits to player account and close session
class CashOutService
  class AlreadyCashedOutError < StandardError; end
  class SessionClosedError < StandardError; end
  class NoCreditsError < StandardError; end

  def self.call(session:)
    new(session:).call
  end

  def initialize(session:)
    @session = session
  end

  def call
    # keep locked during whole operation
    @session.with_lock do
      raise SessionClosedError, 'session closed' if @session.status != 'open'
      raise NoCreditsError, 'no credits' if @session.credits <= 0

      amount = @session.credits
      player = @session.player

      ActiveRecord::Base.transaction do
        CashOut.create!(
          player_id: player.id,
          game_session_id: @session.id,
          amount: amount
        )

        @session.update!(credits: 0, status: :closed, last_roll_at: Time.current)
        player.update!(account_credits: player.account_credits + amount)
      end

      {moved: true, amount: amount, account_credits: player.account_credits}
    end
  rescue ActiveRecord::RecordNotUnique
    raise AlreadyCashedOutError, 'already cashed out'
  end
end

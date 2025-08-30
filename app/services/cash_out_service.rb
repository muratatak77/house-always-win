class CashOutService
  # stub service: do nothing, just echo numbers
  def self.call(session:)
    player = session.player
    {
      moved: false,
      amount: 0,
      account_credits: player.account_credits
    }
  end
end

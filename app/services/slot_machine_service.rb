
class SlotMachineService
  # stub errors kept for later real impl
  class SessionClosedError < StandardError; end
  class NoCreditsError < StandardError; end

  SYMBOLS = %w[C L O W].freeze

  def self.call(session:, rng: Random)
    new(session:, rng:).call
  end

  def initialize(session:, rng: Random)
    @session = session
    @rng = rng
  end

  def call
    {
      symbols: %w[C L O],
      win: false,
      reward: 0,
      cheated: false,
      credits: @session.credits
    }
  end
end

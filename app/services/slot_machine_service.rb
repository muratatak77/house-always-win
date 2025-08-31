# frozen_string_literal: true

class SlotMachineService
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
    # keep locked during whole operation
    @session.with_lock do
      ensure_ok!

      round = do_spin # {symbols:, reward:, win:, cheated?}
      round = maybe_reroll(round) # maybe change symbols, set cheated flag
      next_credit = credits_after(round) # compute next credits (may raise)

      save_round!(round, next_credit) # write Roll + update session
      build_payload(round, next_credit) # final hash for controller
    end
  end

  private

  # session must be playable
  def ensure_ok!
    raise SessionClosedError, 'closed' if @session.status != 'open'
    raise NoCreditsError, 'no credits' if @session.credits <= 0
  end

  # one spin, calc reward
  def do_spin
    s = pick_three
    r = RewardService.for_symbols(s)
    {symbols: s, reward: r, win: r.positive?, cheated: false}
  end

  # house maybe re-roll if win and credits high
  def maybe_reroll(round)
    want = CheatLogicService.should_reroll?(
      credits: @session.credits,
      win: round[:win],
      rng: @rng
    )
    return round unless want

    s2 = pick_three
    r2 = RewardService.for_symbols(s2)
    {symbols: s2, reward: r2, win: r2.positive?, cheated: true}
  end

  # next credits after this round
  def credits_after(round)
    val = round[:win] ? (@session.credits + round[:reward]) : (@session.credits - 1)
    raise NoCreditsError, 'no credits' if val.negative?

    val
  end

  # persist db stuff
  def save_round!(round, next_credit)
    Roll.create!(
      game_session: @session,
      symbols: round[:symbols],
      win: round[:win],
      reward: round[:reward],
      cheated: round[:cheated]
    )
    @session.update!(credits: next_credit, last_roll_at: Time.current)
  end

  # make api json
  def build_payload(round, next_credit)
    {
      symbols: round[:symbols],
      win: round[:win],
      reward: round[:reward],
      cheated: round[:cheated],
      credits: next_credit
    }
  end

  # pick 3 letters using rng
  def pick_three
    [SYMBOLS.sample(random: @rng),
     SYMBOLS.sample(random: @rng),
     SYMBOLS.sample(random: @rng)]
  end
end

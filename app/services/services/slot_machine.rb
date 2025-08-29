module Services
  class SlotMachine
    SYMBOLS = %w[C L O W].freeze

    def roll
      Array.new(3) { SYMBOLS.sample }
    end
  end
end

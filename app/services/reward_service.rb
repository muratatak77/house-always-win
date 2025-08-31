# frozen_string_literal: true

class RewardService
  TABLE = {'C' => 10, 'L' => 20, 'O' => 30, 'W' => 40}.freeze

  # win only if all three same
  def self.for_symbols(symbols)
    arr = Array(symbols)
    return 0 unless arr.size == 3 && arr.uniq.size == 1

    TABLE.fetch(arr.first, 0)
  end
end

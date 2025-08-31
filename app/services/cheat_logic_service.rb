# frozen_string_literal: true

# house maybe cheat when user too rich
class CheatLogicService
  def self.should_reroll?(credits:, win:, rng: Random)
    return false unless win

    if credits.between?(40, 60)
      rng.rand < 0.30
    elsif credits > 60
      rng.rand < 0.60
    else
      false
    end
  end
end

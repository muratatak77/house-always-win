# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheatLogicService do
  describe '.should_reroll?' do
    it 'false when not win' do
      fake = double(:rng, rand: 0.0)
      expect(described_class.should_reroll?(credits: 50, win: false, rng: fake)).to be(false)
    end

    it '30% zone: true below 0.30, false above' do
      expect(described_class.should_reroll?(credits: 50, win: true, rng: double(rand: 0.29))).to be(true)
      expect(described_class.should_reroll?(credits: 50, win: true, rng: double(rand: 0.31))).to be(false)
    end

    it '60% zone: true below 0.60, false above' do
      expect(described_class.should_reroll?(credits: 70, win: true, rng: double(rand: 0.59))).to be(true)
      expect(described_class.should_reroll?(credits: 70, win: true, rng: double(rand: 0.61))).to be(false)
    end

    it 'no cheat when credits < 40' do
      expect(described_class.should_reroll?(credits: 39, win: true, rng: double(rand: 0.0))).to be(false)
    end
  end
end

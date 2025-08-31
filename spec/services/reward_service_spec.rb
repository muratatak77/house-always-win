require "rails_helper"

RSpec.describe RewardService do
  describe ".for_symbols" do
    it "gives reward when three same" do
      expect(described_class.for_symbols(%w[C C C])).to eq(10)
      expect(described_class.for_symbols(%w[L L L])).to eq(20)
      expect(described_class.for_symbols(%w[O O O])).to eq(30)
      expect(described_class.for_symbols(%w[W W W])).to eq(40)
    end

    it "zero when not all same" do
      expect(described_class.for_symbols(%w[C L C])).to eq(0)
      expect(described_class.for_symbols(%w[W O W])).to eq(0)
    end

    it "zero when symbol not in table" do
      expect(described_class.for_symbols(%w[X X X])).to eq(0)
    end

    it "zero when size not 3 or nil" do
      expect(described_class.for_symbols(nil)).to eq(0)
      expect(described_class.for_symbols([])).to eq(0)
      expect(described_class.for_symbols(%w[C C])).to eq(0)
      expect(described_class.for_symbols(%w[C C C C])).to eq(0)
    end
  end
end

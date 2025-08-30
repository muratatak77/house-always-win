require "rails_helper"

RSpec.describe SlotMachineService do
  subject(:slot_machine) { described_class.new }

  describe "#roll" do
    it "returns 3 symbols" do
      result = slot_machine.roll
      expect(result.size).to eq(3)
    end
  end
end

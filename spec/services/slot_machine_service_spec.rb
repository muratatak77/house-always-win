# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlotMachineService do
  describe '.call' do
    it 'lose path: minus 1 credit, saves roll' do
      gs = create(:game_session, status: :open, credits: 10)

      # no cheat, symbols not same
      allow(CheatLogicService).to receive(:should_reroll?).and_return(false)
      allow_any_instance_of(described_class).to receive(:pick_three).and_return(%w[C L O])

      res = described_class.call(session: gs)

      expect(res[:win]).to be(false)
      expect(res[:reward]).to eq(0)
      expect(res[:credits]).to eq(9)
      expect(gs.reload.credits).to eq(9)

      roll = Roll.order(:id).last
      expect(roll.symbols).to eq(%w[C L O])
      expect(roll.win).to be(false)
      expect(roll.cheated).to be(false)
    end

    it 'win path no cheat: add reward to credits' do
      gs = create(:game_session, status: :open, credits: 10)

      allow(CheatLogicService).to receive(:should_reroll?).and_return(false)
      allow_any_instance_of(described_class).to receive(:pick_three).and_return(%w[C C C]) # reward 10

      res = described_class.call(session: gs)

      expect(res[:win]).to be(true)
      expect(res[:reward]).to eq(10)
      expect(res[:credits]).to eq(20)
      expect(gs.reload.credits).to eq(20)

      roll = Roll.order(:id).last
      expect(roll.symbols).to eq(%w[C C C])
      expect(roll.win).to be(true)
      expect(roll.cheated).to be(false)
    end

    it 'win then cheat reroll to lose' do
      gs = create(:game_session, status: :open, credits: 50) # in cheat zone

      # first says: yes, we cheat (reroll)
      allow(CheatLogicService).to receive(:should_reroll?).and_return(true)

      # first spin win, second spin lose
      allow_any_instance_of(described_class)
        .to receive(:pick_three)
        .and_return(%w[W W W], %w[C L O])

      res = described_class.call(session: gs)

      expect(res[:cheated]).to be(true)
      expect(res[:win]).to be(false)
      expect(res[:reward]).to eq(0)
      expect(res[:credits]).to eq(49)
      expect(gs.reload.credits).to eq(49)

      roll = Roll.order(:id).last
      expect(roll.symbols).to eq(%w[C L O])
      expect(roll.win).to be(false)
      expect(roll.cheated).to be(true)
    end

    it 'raises when session closed' do
      gs = create(:game_session, status: :closed, credits: 10)

      expect do
        described_class.call(session: gs)
      end.to raise_error(SlotMachineService::SessionClosedError)
    end

    it 'raises when no credits' do
      gs = create(:game_session, status: :open, credits: 0)

      expect do
        described_class.call(session: gs)
      end.to raise_error(SlotMachineService::NoCreditsError)
    end
  end
end

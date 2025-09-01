require 'rails_helper'

RSpec.describe Api::V1::GameSessionPresenter do
  let(:game_session) do
    double(
      'GameSession',
      id: 123,
      player_id: 456,
      credits: 1000,
      status: 'open',
      last_roll_at: Time.parse('2023-01-01 12:00:00 UTC')
    )
  end
  subject(:presenter) { described_class.new(game_session) }

  describe '#as_json' do
    it 'returns correct json structure' do
      expect(presenter.as_json).to eq({
        id: 123,
        player_id: 456,
        credits: 1000,
        status: 'open',
        last_roll_at: Time.parse('2023-01-01 12:00:00 UTC')
      })
    end

    it 'includes all required fields' do
      json = presenter.as_json
      expect(json.keys).to contain_exactly(:id, :player_id, :credits, :status, :last_roll_at)
    end

    context 'with nil values' do
      let(:game_session) do
        double(
          'GameSession',
          id: nil,
          player_id: nil,
          credits: nil,
          status: nil,
          last_roll_at: nil
        )
      end

      it 'handles nil values correctly' do
        expect(presenter.as_json).to eq({
          id: nil,
          player_id: nil,
          credits: nil,
          status: nil,
          last_roll_at: nil
        })
      end
    end
  end
end
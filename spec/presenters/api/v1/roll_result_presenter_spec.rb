# spec/presenters/api/v1/roll_result_presenter_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::RollResultPresenter do
  let(:result_data) do
    {
      symbols: ['cherry', 'lemon', 'seven'],
      win: true,
      reward: 100,
      cheated: false,
      credits: 500
    }
  end
  subject(:presenter) { described_class.new(result_data) }

  describe '#as_json' do
    it 'returns correct json structure' do
      expect(presenter.as_json).to eq({
        symbols: ['cherry', 'lemon', 'seven'],
        win: true,
        reward: 100,
        cheated: false,
        credits: 500
      })
    end

    it 'includes all required fields' do
      json = presenter.as_json
      expect(json.keys).to contain_exactly(:symbols, :win, :reward, :cheated, :credits)
    end

    context 'with cheated true' do
      let(:result_data) do
        {
          symbols: ['seven', 'seven', 'seven'],
          win: true,
          reward: 1000,
          cheated: true,
          credits: 1500
        }
      end

      it 'returns true for cheated' do
        expect(presenter.as_json[:cheated]).to be true
      end
    end

    context 'with loss result' do
      let(:result_data) do
        {
          symbols: ['cherry', 'lemon', 'bar'],
          win: false,
          reward: 0,
          cheated: false,
          credits: 400
        }
      end

      it 'returns false for win' do
        expect(presenter.as_json[:win]).to be false
      end

      it 'returns 0 for reward' do
        expect(presenter.as_json[:reward]).to eq(0)
      end
    end
  end
end
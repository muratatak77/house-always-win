require 'rails_helper'

RSpec.describe Api::V1::CashOutResultPresenter do
  let(:result_data) do
    {
      moved: true,
      amount: 150,
      account_credits: 500
    }
  end
  subject(:presenter) { described_class.new(result_data) }

  describe '#as_json' do
    it 'returns correct json structure' do
      expect(presenter.as_json).to eq({
        moved: true,
        amount: 150,
        account_credits: 500
      })
    end

    it 'includes all required fields' do
      json = presenter.as_json
      expect(json.keys).to contain_exactly(:moved, :amount, :account_credits)
    end

    context 'with false moved value' do
      let(:result_data) { { moved: false, amount: 0, account_credits: 100 } }

      it 'returns false for moved' do
        expect(presenter.as_json[:moved]).to be false
      end
    end
  end
end
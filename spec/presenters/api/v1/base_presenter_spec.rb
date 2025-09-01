require 'rails_helper'

RSpec.describe Api::V1::BasePresenter do
  let(:test_object) { double('TestObject') }
  subject(:presenter) { described_class.new(test_object) }

  describe '#initialize' do
    it 'sets the object' do
      expect(presenter.send(:object)).to eq(test_object)
    end
  end

  describe '#as_json' do
    it 'raises NotImplementedError' do
      expect { presenter.as_json }.to raise_error(NotImplementedError, 'Subclasses must implement as_json')
    end
  end
end
require './src/checkout'

class DummyRules
  def self.call(items)
    items
  end
end

Item = Struct.new(:price)

RSpec.describe Checkout do
  
  subject { Checkout.new(DummyRules) }

  describe '#scan' do
    it 'accepts single parameter' do
      expect do
        subject.scan('foo')
      end.not_to raise_error
    end
  end

  describe '#total' do
    let(:item1) { Item.new 10.501 }
    let(:item2) { Item.new 20.0 }

    before do
      subject.scan(item1)
      subject.scan(item2)

      allow(DummyRules).to receive(:call).and_call_original
    end

    it 'returns sum of items prices' do
      expected_result = (item1.price + item2.price).round(2)

      expect(subject.total).to eq(expected_result)
      expect(DummyRules).to have_received(:call).with([item1, item2])
    end
  end
end

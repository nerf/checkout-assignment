require './src/checkout'

class DummyRules
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
    let(:item1) { Item.new 10.5 }
    let(:item2) { Item.new 20.0 }

    before do
      subject.scan(item1)
      subject.scan(item2)
    end

    it 'returns sum of items prices' do
      expect(subject.total).to eq(30.5)
    end
  end
end

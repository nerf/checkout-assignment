require './src/simple_rule_engine/rule'

RSpec.describe SimpleRuleEngine::Rule do
  subject { described_class.new }

  describe '#when' do
    it 'can be called with block' do
      expect do
        subject.when { }
      end.not_to raise_error
    end

    it 'raises error when block is not givene' do
      expect do
        subject.when()
      end.to raise_error(ArgumentError)
    end
  end

  describe '#then' do
    it 'can be called with block' do
      expect do
        subject.then { }
      end.not_to raise_error
    end

    it 'raises error when block is not givene' do
      expect do
        subject.then()
      end.to raise_error(ArgumentError)
    end
  end
end

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

  describe '#name' do
    it 'can be set' do
      subject.name = 'Foo rule'

      expect(subject.name).to eq('Foo rule')
    end
  end

  describe '#priority' do
    it 'can be set' do
      subject.priority = 100

      expect(subject.priority).to eq(100)
    end
  end

  describe '#execute' do
    before do
      subject.when do |obj|
        obj.length == 2
      end
      subject.when do |obj|
        obj[0] == 1
      end
      subject.then do |obj|
        obj[0] = 'changed'
      end
      subject.then do |obj|
        obj[1] = 'changed'
      end

      subject.execute(object)
    end

    context 'with matching rules' do
      let(:object) { [1, 2] }

      it 'applies mutations' do
        expect(object).to eq(%w(changed changed))
      end
    end

    context 'without matching rules' do
      let(:object) { [2, 3] }

      it 'mutations are not applied' do
        expect(object).to eq([2, 3])
      end
    end
  end
end

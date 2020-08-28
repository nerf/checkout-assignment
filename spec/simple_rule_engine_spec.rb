require './src/simple_rule_engine'

RSpec.describe SimpleRuleEngine do
  subject { described_class }

  before { subject.reset_rules! }

  describe '.add_rule' do
    before do
      subject.add_rule do |rule|
        rule.name = 'Foo'
        rule.priority = 10
      end
      subject.add_rule do |rule|
        rule.name = 'Bar'
        rule.priority = 1
      end
    end

    it 'saves provided rule in correct order' do
      expected_result = [
        { name: 'Bar', priority: 1 },
        { name: 'Foo', priority: 10 },
      ]

      expect(subject.list_rules).to eq(expected_result)
    end
  end

  describe '.reset_rules!' do
    before do
      subject.add_rule { }
    end

    it 'clears all rules' do
      expect(subject.list_rules).not_to be_empty

      subject.reset_rules!

      expect(subject.list_rules).to be_empty
    end
  end

  describe '.call' do
    before do
      subject.add_rule do |rule|
        rule.when { true }
        rule.then { |obj| 
          obj[0] = 'B'
        }
      end
    end

    it 'executes provided rules' do
      result = subject.call('foo')

      expect(result).to eq('Boo')
    end

    it 'return mutated copy of original object' do
      original = 'Foo'

      expect(subject.call(original)).to eq('Boo')
      expect(original).to eq('Foo')
    end
  end
end

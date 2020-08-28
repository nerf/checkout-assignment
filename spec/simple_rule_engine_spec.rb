require './src/simple_rule_engine'

RSpec.describe SimpleRuleEngine do
  subject { described_class }

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

    it 'saves provided rule' do
      expected_result = [
        { name: 'Bar', priority: 1 },
        { name: 'Foo', priority: 10 },
      ]

      expect(subject.list_rules).to eq(expected_result)
    end
  end
end

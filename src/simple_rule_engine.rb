class SimpleRuleEngine
  @@rules = []

  def self.add_rule
    rule = Rule.new

    yield rule if block_given?

    @@rules = (@@rules + [rule]).sort_by(&:priority)
  end

  def self.list_rules
    @@rules.each_with_object([]) do |rule, obj|
      obj << { name: rule.name, priority: rule.priority }
    end
  end
end

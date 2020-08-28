require_relative './simple_rule_engine/rule'

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

  def self.reset_rules!
    @@rules = []
  end

  def self.call(object)
    object_copy = object.dup

    @@rules.each do |rule|
      rule.execute(object_copy)
    end

    object_copy
  end
end

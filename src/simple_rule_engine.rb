require_relative './simple_rule_engine/rule'

class SimpleRuleEngine

  def initialize
    @rules = []
  end

  def add_rule
    rule = Rule.new

    if block_given?
      yield rule
    else
      raise ArgumentError, "`add_rule` method expects block"
    end

    @rules = (rules + [rule]).sort_by(&:priority)
  end

  def list_rules
    rules.each_with_object([]) do |rule, obj|
      obj << { name: rule.name, priority: rule.priority }
    end
  end

  def reset_rules!
    @rules = []
  end

  def call(object)
    object_copy = deep_dup(object)

    rules.each do |rule|
      rule.execute(object_copy)
    end

    object_copy
  end

  private

  attr_reader :rules

  def deep_dup(obj)
    if obj.is_a?(Array)
      obj.map(&:dup)
    else
      obj.dup
    end
  end
end

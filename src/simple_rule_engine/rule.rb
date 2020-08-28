class SimpleRuleEngine
  class Rule

    attr_accessor :name, :priority

    def initialize
      @name = nil
      @priority = 0
      @when_list = []
      @then_list = []
    end

    def when
      raise ArgumentError unless block_given?
    end

    def then
      raise ArgumentError unless block_given?
    end
  end
end

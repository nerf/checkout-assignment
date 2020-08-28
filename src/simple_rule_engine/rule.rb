class SimpleRuleEngine
  class Rule

    attr_accessor :name, :priority

    def initialize
      @name = nil
      @priority = 0
      @when_list = []
      @then_list = []
    end

    def when(&block)
      raise ArgumentError, 'Expect to receive block.' unless block_given?

      when_list << block
    end

    def then(&block)
      raise ArgumentError, 'Expect to receive block.' unless block_given?

      then_list << block
    end

    def execute(object)
      return unless meets_all_requirements?(object)

      apply_mutations(object)

      object
    end

    private

    attr_reader :when_list, :then_list

    def meets_all_requirements?(object)
      when_list.each do |requirement|
        return false unless requirement.call(object)
      end
    end

    def apply_mutations(object)
      then_list.each do |mutation|
        mutation.call(object)
      end
    end
  end
end

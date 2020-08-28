class Checkout
  def initialize(rules)
    @rules = rules
    @items = []
  end

  def scan(item)
    items << item
  end

  def total
    rules.call(items).inject(0) { |total, i| total += i.price }.round(2)
  end

  private

  attr_reader :rules, :items
end

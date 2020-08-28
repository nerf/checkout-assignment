#!/usr/bin/env ruby

require_relative '../src/item'
require_relative '../src/checkout'
require_relative '../src/simple_rule_engine'

# Helpers
def subtract_percentage(number, percentage)
  number - ((number / 100) * percentage)
end

# Add dummy data
AVAILABLE_ITEMS = {
  '001' => Item.new(product_code: '001', name: 'Lavender heart', price: 9.25),
  '002' => Item.new(product_code: '002', name: 'Personalised cufflinks', price: 45.00),
  '003' => Item.new(product_code: '003', name: 'Kids T-shirt', price: 19.95)
}

# Add rules
SimpleRuleEngine.add_rule do |rule|
  rule.name = 'Discount for orders over £60'
  rule.priority = 100
  rule.when do |items|
    items.inject(0) { |total, i| total += i.price } > 60.00
  end
  rule.then do |items|
    items.each do |item|
      item.price = subtract_percentage(item.price, 10)
    end
  end
end

SimpleRuleEngine.add_rule do |rule|
  rule.name = 'Lavender hearts discount'
  rule.priority = 10
  rule.when do |items|
    items.select { |item| item.product_code == '001' }.length > 1
  end
  rule.then do |items|
    items.each do |item|
      item.price = 8.5 if item.product_code == '001'
    end
  end
end

checkout = Checkout.new(SimpleRuleEngine)
ARGV.each do |key|
  if AVAILABLE_ITEMS.key?(key)
    item = AVAILABLE_ITEMS[key]

    puts "Adding item: #{item.name} - #{item.price}"
    checkout.scan(item)
  else
    exit "Item with product code: `#{key}` does not exists."
  end
end

puts "Your order total is: £#{checkout.total}"

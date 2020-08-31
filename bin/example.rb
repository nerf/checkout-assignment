#!/usr/bin/env ruby

require_relative '../src/item'
require_relative '../src/checkout'
require_relative '../src/simple_rule_engine'

UNKNOWN_PRODUCT = "Item with product code: `%s` does not exists."
HELP = <<-EOF
  Example usage:
    `#{$0} 001 002 003 001`
    `#{$0} 001,002,003`
EOF

# Add dummy data
AVAILABLE_ITEMS = {
  '001' => Item.new(product_code: '001', name: 'Lavender heart', price: 9.25),
  '002' => Item.new(product_code: '002', name: 'Personalised cufflinks', price: 45.00),
  '003' => Item.new(product_code: '003', name: 'Kids T-shirt', price: 19.95)
}

# Helpers
def subtract_percentage(number, percentage)
  number - ((number / 100) * percentage)
end

def get_arguments_list
  abort(HELP) if ARGV.empty?

  ARGV.length > 1 ? ARGV : ARGV.first.split(',')
end

# Add rules
rules = SimpleRuleEngine.new

rules.add_rule do |rule|
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

rules.add_rule do |rule|
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

# Init checkout
checkout = Checkout.new(rules)

# Add items to checkout
get_arguments_list.each do |product_code|
  abort(UNKNOWN_PRODUCT % product_code) unless AVAILABLE_ITEMS.key?(product_code)

  item = AVAILABLE_ITEMS[product_code]

  puts "Adding item: #{item.name} - #{item.price}"

  checkout.scan(item)
end

# Get order total
puts "Your order total is: £#{checkout.total}"

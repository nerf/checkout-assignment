# README

### Notes

* Project doesn't have `Gemfile` because is using only ruby stdlib.
* Item model validation is out of scope.

### How to test

```
  > bin/example.rb 001 002 003
  Adding item: Lavender heart - 9.25
  Adding item: Personalised cufflinks - 45.0
  Adding item: Kids T-shirt - 19.95
  Your order total is: £66.78
```

### APIs overview

#### Checkout

```
  checkout = Checkout.new(rules)
  checkout.scan(item)
  checkout.total
```

#### Rule engine

To add rule

```
  rules = SimpleRuleEngine.new
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
```

List rules

```
  rules.list_rules # [{name: 'Rule', priority: 1}]
```

Reset/clear rules

```
  rules.reset_rules!
```

Execute rules

```
  rules.call(objects_to_be_processed)
```

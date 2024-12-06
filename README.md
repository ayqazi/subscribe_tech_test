# SUBSCRIBE Tech Test

This app takes a basket in the form of JSON piped to STDIN and calculates a receipt, including sales tax and total.

JSON was chosen as input as it removed the need for fancy input handling to get the basket details.

Each basket item contains a name, quantity, category, and gross unit price. There is also an imported flag. For an example, see the files in the `inputs` directory, like [inputs/input1.json](inputs/input1.json).

"Category" is used to identify basic sales tax exemption status. "book", "food", or "medical" items are exempt from basic sales tax.

When calculating tax for multiple quantities of an item, tax is calculated per item, rounded as per specified rules, and then multiplied by quantity.

The `Basket` and `BasketItem` classes manage the basket content, and the `TaxCalculation` module centralizes the tax calculation. As specified below, a more granular class structure could have been adopted but was not due to concerns around simplicity and time limits.

# Running

Set up environment:

```shell
bundle
```

Run tests:
```shell
bundle exec rspec
```

Run with test input 1:
```shell
bundle exec bin/receipt < inputs/input1.json
```
==>
```
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32
```

Run with test input 2:
```shell
bundle exec bin/receipt < inputs/input2.json
```
==>
```
1 imported box of chocolates: 10.50
1 imported bottle of perfume: 54.65
Sales Taxes: 7.65
Total: 65.15
```

Run with test input 3:
```shell
bundle exec bin/receipt < inputs/input3.json
```
==>
```
1 imported bottle of perfume: 32.19
1 bottle of perfume: 20.89
1 packet of headache pills: 9.75
3 imported box of chocolates: 35.55
Sales Taxes: 7.90
Total: 98.38
```

Other inputs can provided by using those input files as a template and modifying them as desired.

# Thoughts on decisions

## No input validation

As the input is JSON, I would have used a JSON schema to validate it. But as we cannot use external libraries, I could not import and use the json-schema gem. Hence I made liberal use of the `fetch` method so it would break noisily if something expected was missing.

## Breaking the single responsibility principle

Generating receipt text is technically not the Basket or BasketItem classes job. If we wanted to SRP to the extreme, we'd have a ReceiptLineGenerator and ReceiptGenerator which would take BasketItem or Basket respectively and generate the text.

However, to be pragmatic, we include that functionality in the Basket classes since it makes things much simpler to navigate and read.

But of course we can factor them out later should things become more complex or we have to output different formats.

## Non-DRY tests

Tests by their nature should be as simple as possible; the more complication there is in a test, the more chance of false positives now or in the future as the code evolves. So I personally prefer to keep tests on the repetitive side and not DRY too enthusiastically.

It also makes them more readable as I can read a test and understand it without jumping back and forth between the test code and the custom matcher code.

This is also a useful "test smell" - if large swathes of code are repeated in a test, it may indicate the need to factor out components.

I must point out that I believe common use cases, like testing an attr accessor exists, can certainly be tested using factored out helpers or custom matchers, as the overhead is worth the constant repetition across an entire codebase. As with all things, there is a balance between overhead and tidiness that must be found.

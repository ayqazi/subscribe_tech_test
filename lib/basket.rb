# frozen_string_literal: true

require 'basket_item'

class Basket
  def initialize(basket_items)
    @items = basket_items
  end

  def items
    @items.dup.freeze
  end

  def [](index)
    @items[index]
  end

  def add(item)
    @items.push item
  end

  def receipt_lines
    item_lines = []
    total_tax = 0
    grand_total = 0

    items.each do |item|
      line_price, tax = item.amounts
      item_lines.push "#{item.formatted_name}: #{format_price line_price}"
      total_tax += tax
      grand_total += line_price
    end

    [
      *item_lines,
      "Sales Taxes: #{format_price total_tax}",
      "Total: #{format_price grand_total}"
    ]
  end

  private

  def format_price(price_pence)
    format('%.2f', price_pence.to_f / 100)
  end
end

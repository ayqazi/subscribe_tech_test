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
end

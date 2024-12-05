# frozen_string_literal: true

require 'tax_calculation'

TAX_EXEMPT_CATEGORIES = Set['food', 'book', 'medical'].freeze

BasketItem = Struct.new(:name, :quantity, :gross_unit_price_pence, :imported, :category) do
  include TaxCalculation

  def formatted_name
    [
      quantity,
      imported ? 'imported' : nil,
      name
    ].compact.join(' ')
  end

  def amounts
    unit_tax = calculate_taxes(gross_unit_price_pence, imported, TAX_EXEMPT_CATEGORIES.include?(category))
    [
      (gross_unit_price_pence + unit_tax) * quantity,
      unit_tax * quantity
    ]
  end
end

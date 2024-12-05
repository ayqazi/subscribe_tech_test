# frozen_string_literal: true

require 'tax_calculation'

BasketItem = Struct.new(:name, :quantity, :gross_unit_price_pence, :imported) do
  include TaxCalculation

  def formatted_name
    [
      quantity,
      imported ? 'imported' : nil,
      name
    ].compact.join(' ')
  end

  def amounts
    line_price_pence = gross_unit_price_pence * quantity
    tax = calculate_taxes(line_price_pence, imported, false)
    [
      line_price_pence + tax,
      tax
    ]
  end
end

# frozen_string_literal: true

BasketItem = Struct.new(:name, :quantity, :gross_unit_price_pence, :imported) do
  def formatted_name
    [
      quantity,
      imported ? 'imported' : nil,
      name
    ].compact.join(' ')
  end

  def amounts
    [
      gross_unit_price_pence * quantity,
      0
    ]
  end
end

# frozen_string_literal: true

module TaxCalculation
  def calculate_taxes(amount_pence, imported, tax_exempt)
    sales_tax = if tax_exempt
                  0.0
                else
                  amount_pence.to_f * 0.10
                end
    import_duty = if imported
                    amount_pence.to_f * 0.05
                  else
                    0.0
                  end

    round_to_nearest_5p(sales_tax).to_i + round_to_nearest_5p(import_duty).to_i
  end

  private

  def round_to_nearest_5p(value)
    (value / 5).round * 5
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :basket_item do
    sequence(:name) { |n| "Basket Item #{n}" }
    quantity { rand(1..10) }
    gross_unit_price_pence { rand(49..1599) }
    imported { false }
  end
end

# frozen_string_literal: true

require 'basket_item'

RSpec.describe BasketItem do
  subject(:basket_item) do
    described_class.new name: 'TEST ITEM', quantity: 2, gross_unit_price_pence: 299, imported: false, category: 'misc'
  end

  before do
    allow(basket_item).to receive(:calculate_taxes).and_return(7)
  end

  describe 'attributes', :aggregate_failures do
    it 'can be initialized' do
      expect(basket_item.name).to eq 'TEST ITEM'
      expect(basket_item.quantity).to eq 2
      expect(basket_item.gross_unit_price_pence).to eq 299
      expect(basket_item.imported).to be false
      expect(basket_item.category).to be 'misc'
    end

    it 'can set and retrieve #name' do
      basket_item.name = 'TEST ITEM 2'
      expect(basket_item.name).to eq 'TEST ITEM 2'
    end

    it 'can set and retrieve #quantity' do
      basket_item.quantity = 3
      expect(basket_item.quantity).to eq 3
    end

    it 'can set and retrieve #shelf_price_pence' do
      basket_item.gross_unit_price_pence = 4
      expect(basket_item.gross_unit_price_pence).to eq 4
    end

    it 'can set and retrieve #imported' do
      basket_item.imported = true
      expect(basket_item.imported).to be true
    end

    it 'can set and retrieve #category' do
      basket_item.category = 'book'
      expect(basket_item.category).to eq 'book'
    end
  end

  describe '#formatted_name' do
    it 'is name for receipt for domestic items' do
      expect(basket_item.formatted_name).to eq '2 TEST ITEM'
    end

    it 'is name for receipt for imported items' do
      basket_item.imported = true
      expect(basket_item.formatted_name).to eq '2 imported TEST ITEM'
    end
  end

  describe '#amounts' do
    it 'returns line price including tax and the amount of tax charged' do
      expect(basket_item.amounts).to eq [612, 14]
    end

    it 'uses SalesTaxCalculation#calculate_taxes' do
      expect(described_class.ancestors).to include TaxCalculation
    end

    it 'uses SalesTaxCalculation module to calculate sales tax for domestic items' do
      basket_item.amounts
      expect(basket_item).to have_received(:calculate_taxes).with(299, false, false).once
    end

    it 'uses SalesTaxCalculation module to calculate sales tax for imported items' do
      basket_item.imported = true
      basket_item.amounts
      expect(basket_item).to have_received(:calculate_taxes).with(299, true, false).once
    end

    it 'uses SalesTaxCalculation module to calculate sales tax for non-taxable domestic items', :aggregate_failures do
      %w[food book medical].each do |tax_exempt_category|
        basket_item.category = tax_exempt_category
        basket_item.amounts
      end

      expect(basket_item).to have_received(:calculate_taxes).with(299, false, true).exactly(3).times
    end

    it 'uses SalesTaxCalculation module to calculate sales tax for non-taxable imported items', :aggregate_failures do
      basket_item.imported = true
      %w[food book medical].each do |tax_exempt_category|
        basket_item.category = tax_exempt_category
        basket_item.amounts
      end

      expect(basket_item).to have_received(:calculate_taxes).with(299, true, true).exactly(3).times
    end
  end
end

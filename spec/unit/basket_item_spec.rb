# frozen_string_literal: true

require 'basket_item'

RSpec.describe BasketItem do
  subject(:basket_item) do
    described_class.new name: 'TEST ITEM', quantity: 2, gross_unit_price_pence: 299, imported: false
  end

  describe 'attributes', :aggregate_failures do
    it 'can be initialized' do
      expect(basket_item.name).to eq 'TEST ITEM'
      expect(basket_item.quantity).to eq 2
      expect(basket_item.gross_unit_price_pence).to eq 299
      expect(basket_item.imported).to be false
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
    it 'returns line price including tax and tax for all items' do
      expect(basket_item.amounts).to eq [598, 0]
    end
  end
end

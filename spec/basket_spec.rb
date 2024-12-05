# frozen_string_literal: true

require 'basket'

RSpec.describe Basket do
  subject(:basket) { described_class.new(basket_items) }

  let(:basket_items) do
    [instance_double(BasketItem, :item1), instance_double(BasketItem, :item2), instance_double(BasketItem, :item3)]
  end

  context 'when managing BasketItems' do
    it 'can be initialized with them' do
      expect(basket.items).to eq basket_items
    end

    it 'can add them' do
      item = FactoryBot.build(:basket_item)
      basket.add(item)
      expect(basket.items).to eq basket_items
    end

    it 'can retrieve them individually' do
      expect(basket[1]).to eq basket_items[1]
    end

    it 'can retrieve them as a frozen list', :aggregate_failures do
      expect(basket.items).to eq basket_items
      expect(basket.items).to be_frozen
    end
  end

  context 'when outputting receipts' do
    subject(:basket) do
      described_class.new(basket_items)
    end

    let(:basket_items) do
      [
        instance_double(BasketItem, :item1, formatted_name: '1 Toy', amounts: [299, 12]),
        instance_double(BasketItem, :item2, formatted_name: '2 Gadget', amounts: [2000, 155])
      ]
    end

    it 'outputs basket item lines' do
      expect(basket.receipt_lines[0..1]).to eq(['1 Toy: 2.99', '2 Gadget: 20.00'])
    end

    it 'outputs totals' do
      expect(basket.receipt_lines[-1]).to eq('Total: 22.99')
    end
  end
end

# frozen_string_literal: true

require 'basket'

RSpec.describe Basket do
  subject(:basket) { described_class.new(basket_items) }

  let(:basket_items) { FactoryBot.build_list(:basket_item, 3) }

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
end

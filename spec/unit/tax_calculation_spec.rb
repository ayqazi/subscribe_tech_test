# frozen_string_literal: true

require 'tax_calculation'

RSpec.describe TaxCalculation do
  subject(:taxable) { Class.new.tap { _1.include(described_class) }.new }

  it 'can be included' do
    expect(taxable).to respond_to(:calculate_taxes)
  end

  context 'when calculating tax for domestic sales-taxable items' do
    it 'calculates sales tax at 10%' do
      expect(taxable.calculate_taxes(150, false, false)).to eq(15)
    end

    it 'rounds down sales tax to the nearest 5 pence' do
      # 174p * 10% = 17.4, rounds down to nearest 5p = 15p
      expect(taxable.calculate_taxes(174, false, false)).to eq(15)
    end

    it 'rounds up sales tax to the nearest 5 pence' do
      # 175p * 10% = 17.5, rounds up to nearest 5p = 20
      expect(taxable.calculate_taxes(175, false, false)).to eq(20)
    end
  end

  context 'when calculating tax for imported sales-taxable items' do
    it 'separately calculates sales tax at 10% and import duty at 5%' do
      # 100p * 10% = 10p sales tax
      # 100p * 5% = 5p import duty
      expect(taxable.calculate_taxes(100, true, false)).to eq(15)
    end

    it 'separately rounds down both taxes to the nearest 5 pence' do
      # 105p * 10% = 10.5 sales tax, rounds down to 10p
      # 105p * 5% = 5.25 import duty, rounds down to 5p
      expect(taxable.calculate_taxes(105, true, false)).to eq(15)
    end

    it 'separately rounds sales tax up and import duty down to the nearest 5 pence' do
      # 125p * 10% = 12.5 sales tax, rounds up to 15p
      # 125p * 5% = 6.25 import duty, rounds down to 5p
      expect(taxable.calculate_taxes(125, true, false)).to eq(20)
    end

    it 'separately rounds sales tax down and import duty up to the nearest 5 pence' do
      # 155p * 10% = 15.5 sales tax, rounds down to 15p
      # 155p * 5% = 7.75 import duty, rounds up to 10p
      expect(taxable.calculate_taxes(155, true, false)).to eq(25)
    end

    it 'separately rounds up both taxes to the nearest 5 pence' do
      # 175p * 10% = 17.5 sales tax, rounds up to 20p
      # 175p * 5% = 8.75 import duty, rounds up to 10p
      expect(taxable.calculate_taxes(175, true, false)).to eq(30)
    end
  end

  context 'when calculating tax for imported sales-tax-exempt items' do
    it 'calculates import duty at 5%' do
      expect(taxable.calculate_taxes(100, true, true)).to eq(5)
    end

    it 'rounds down import duty to the nearest 5 pence' do
      # 101p * 5% = 5.05, rounds down to nearest 5p = 5p
      expect(taxable.calculate_taxes(101, true, true)).to eq(5)
    end

    it 'rounds up import duty to the nearest 5 pence' do
      # 151p * 5% = 7.55, rounds up to nearest 5p = 10
      expect(taxable.calculate_taxes(151, true, true)).to eq(10)
    end
  end

  context 'when calculating tax for domestic sales-tax-exempt items' do
    it 'no tax is paid' do
      (0..1000).each do |price_pence|
        expect(taxable.calculate_taxes(price_pence, false, true)).to eq(0)
      end
    end
  end
end

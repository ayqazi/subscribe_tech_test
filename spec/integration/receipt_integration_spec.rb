# frozen_string_literal: true

require 'open3'

RSpec.describe 'bin/receipt', 'integration' do
  def run(input)
    out, err, status = Open3.capture3("#{APP_ROOT}/bin/receipt", stdin_data: input)
    { out:, err:, status: }
  end

  it 'runs without errors', :aggregate_failures do
    result = run('[]')
    expect(result[:status]).to be_a_success
    expect(result[:out]).not_to be_empty
    expect(result[:err]).to be_empty
  end

  it 'produces correct output for "Input 1"', :aggregate_failures do
    input = <<~JSON
      [
        {"quantity": 2, "name": "book", "category": "book", "unitPrice": 12.49},
        {"quantity": 1, "name": "music CD", "category": "misc", "unitPrice": 14.99},
        {"quantity": 1, "name": "chocolate bar", "category": "food", "unitPrice": 0.85}
      ]
    JSON

    result = run(input)

    expect(result[:status]).to be_a_success
    expect(result[:err]).to be_empty
    expect(result[:out]).to eq <<~EOL
      2 book: 24.98
      1 music CD: 16.49
      1 chocolate bar: 0.85
      Sales Taxes: 1.50
      Total: 42.32
    EOL
  end

  it 'produces correct output for "Input 2"', :aggregate_failures do
    input = <<~JSON
      [
        {"quantity": 1, "name": "box of chocolates", "category": "food", "imported": true, "unitPrice": 10.00},
        {"quantity": 1, "name": "bottle of perfume", "category": "misc", "imported": true, "unitPrice": 47.50}
      ]
    JSON

    result = run(input)

    expect(result[:status]).to be_a_success
    expect(result[:err]).to be_empty
    expect(result[:out]).to eq <<~EOL
      1 imported box of chocolates: 10.50
      1 imported bottle of perfume: 54.65
      Sales Taxes: 7.65
      Total: 65.15
    EOL
  end

  it 'produces correct output for "Input 3"', :aggregate_failures do
    input = <<~JSON
      [
        {"quantity": 1, "name": "bottle of perfume", "category": "misc", "imported": true, "unitPrice": 27.99},
        {"quantity": 1, "name": "bottle of perfume", "category": "misc", "unitPrice": 18.99},
        {"quantity": 1, "name": "packet of headache pills", "category": "medical", "unitPrice": 9.75},
        {"quantity": 3, "name": "box of chocolates",  "category": "food", "imported": true, "unitPrice": 11.25}
      ]
    JSON

    result = run(input)

    expect(result[:status]).to be_a_success
    expect(result[:err]).to be_empty
    expect(result[:out]).to eq <<~EOL
      1 imported bottle of perfume: 32.19
      1 bottle of perfume: 20.89
      1 packet of headache pills: 9.75
      3 imported box of chocolates: 35.55
      Sales Taxes: 7.90
      Total: 98.38
    EOL
  end

  it 'produces correct output for a domestic taxable item', :aggregate_failures do
    input = <<~JSON
      [
        {"quantity": 1, "name": "item", "category": "misc", "unitPrice": 18.99}
      ]
    JSON

    result = run(input)

    expect(result[:status]).to be_a_success
    expect(result[:err]).to be_empty
    expect(result[:out]).to eq <<~EOL
      1 item: 20.89
      Sales Taxes: 1.90
      Total: 20.89
    EOL
  end

  it 'produces correct output for a 3-pack of imported tax-exempt item', :aggregate_failures do
    input = <<~JSON
      [
        {"quantity": 3, "name": "item",  "category": "food", "imported": true, "unitPrice": 11.25}
      ]
    JSON

    result = run(input)

    expect(result[:status]).to be_a_success
    expect(result[:err]).to be_empty
    expect(result[:out]).to eq <<~EOL
      3 imported item: 35.55
      Sales Taxes: 1.80
      Total: 35.55
    EOL
  end
end

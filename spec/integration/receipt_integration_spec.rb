# frozen_string_literal: true

require 'open3'

RSpec.describe 'Receipt', 'integration' do
  def run(input)
    out, err, status = Open3.capture3("#{APP_ROOT}/bin/receipt", stdin_data: input)
    { out:, err:, status: }
  end

  it 'runs without errors', :aggregate_failures do
    result = run('x')
    expect(result[:status]).to be_a_success
    expect(result[:out]).not_to be_empty
    expect(result[:err]).to be_empty
  end
end

require "spec_helper"

include Strut

describe ScenarioResult do
  before do
    @sut = ScenarioResult.new
  end

  it 'returns error for scenarios containing exceptions' do
    @sut.add_exception_for_line(5, "exception")
    actual = @sut.result
    expected = SCENARIO_ERROR
    expect(actual).to eq(expected)
  end
end

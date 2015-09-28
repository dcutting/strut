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

  it 'returns failure for scenarios containing failures' do
    @sut.add_ok_for_line(1)
    @sut.add_fail_for_line(5, "failed")
    actual = @sut.result
    expected = SCENARIO_FAIL
    expect(actual).to eq(expected)
  end

  it 'returns first failure message for scenarios containing failures' do
    @sut.add_ok_for_line(1)
    @sut.add_fail_for_line(5, "kind of failed")
    @sut.add_fail_for_line(8, "really failed!")
    actual = @sut.message
    expected = "kind of failed"
    expect(actual).to eq(expected)
  end
end

require "spec_helper"

include Strut

describe Report do
  before do
    @sut = Report.new
  end

  it 'reports 1 total scenario for a single ok' do
    result = ScenarioResult.new
    @sut.add_scenario_result(result)
    expect(@sut.number_scenarios).to eq(1)
    expect(@sut.number_passed).to eq(1)
    expect(@sut.number_failed).to eq(0)
    expect(@sut.number_skipped).to eq(0)
  end

  it 'reports 1 total scenario for a single fail' do
    result = ScenarioResult.new
    result.add_fail_for_line(1, "failed")
    @sut.add_scenario_result(result)
    expect(@sut.number_scenarios).to eq(1)
    expect(@sut.number_passed).to eq(0)
    expect(@sut.number_failed).to eq(1)
    expect(@sut.number_skipped).to eq(0)
  end

  it 'reports 1 total scenario for a single exception' do
    result = ScenarioResult.new
    result.add_exception_for_line(1, "exception")
    @sut.add_scenario_result(result)
    expect(@sut.number_scenarios).to eq(1)
    expect(@sut.number_passed).to eq(0)
    expect(@sut.number_failed).to eq(0)
    expect(@sut.number_skipped).to eq(1)
  end

  it 'reports 1 total scenario for an ok, fail and exception for the same scenario' do
    result = ScenarioResult.new
    result.add_ok_for_line(1)
    result.add_fail_for_line(1, "failed")
    result.add_exception_for_line(1, "exception")
    @sut.add_scenario_result(result)
    expect(@sut.number_scenarios).to eq(1)
    expect(@sut.number_passed).to eq(0)
    expect(@sut.number_failed).to eq(0)
    expect(@sut.number_skipped).to eq(1)
  end

  it 'reports correctly for multiple scenarios' do
    result1 = ScenarioResult.new
    result1.add_ok_for_line(1)
    result2 = ScenarioResult.new
    result2.add_fail_for_line(3, "failed")
    result3 = ScenarioResult.new
    result3.add_exception_for_line(4, "exception")
    @sut.add_scenario_result(result1)
    @sut.add_scenario_result(result2)
    @sut.add_scenario_result(result3)
    expect(@sut.number_scenarios).to eq(3)
    expect(@sut.number_passed).to eq(1)
    expect(@sut.number_failed).to eq(1)
    expect(@sut.number_skipped).to eq(1)
  end
end

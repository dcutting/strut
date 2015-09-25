require "spec_helper"

include Strut

describe ReportJunit do
  before do
    @sut = ReportJunit.new
  end

  it 'returns an empty Junit report for an empty Strut report' do
    report = Report.new
    actual = @sut.format(report)
    expected = "<junit></junit>"
    expect(actual).to eq(expected)
  end

  it 'handles a passing test' do
    report = Report.new
    result = ScenarioResult.new
    result.number = 1
    result.name = "get stuff"
    result.result = SCENARIO_RESULT_PASS
    report.add_scenario_result(result)
    actual = @sut.format(report)
    expected = "<junit><test><name>get stuff</name><result>pass</result></test></junit>"
    expect(actual).to eq(expected)
  end
end

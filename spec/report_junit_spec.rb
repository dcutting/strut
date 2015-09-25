require "spec_helper"
require "rspec/matchers"
require "nokogiri"
require "equivalent-xml"

include Strut

describe ReportJunit do
  before do
    @sut = ReportJunit.new
  end

  it 'returns an empty JUnit report for an empty strut report' do
    report = Report.new
    actual = Nokogiri::XML(@sut.format(report))
    expected_doc = <<XML
<testsuite>
</testsuite>
XML
    expected = Nokogiri::XML(expected_doc)
    expect(actual).to be_equivalent_to(expected)
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

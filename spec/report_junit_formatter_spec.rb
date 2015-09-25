require "spec_helper"
require "rspec/matchers"
require "nokogiri"
require "equivalent-xml"

include Strut

describe ReportJUnitFormatter do
  before do
    @sut = ReportJUnitFormatter.new
  end

  it 'returns an empty JUnit report for an empty strut report' do
    report = Report.new
    actual = @sut.format(report)
    expected = <<XML
<testsuite>
</testsuite>
XML
    expect_equivalent_xml(actual, expected)
  end

  it 'handles some passing tests' do
    result1 = ScenarioResult.new
    result1.name = "201 POST /users"
    result1.time = "0.5"
    result1.result = SCENARIO_PASS
    result2 = ScenarioResult.new
    result2.name = "400 POST /users"
    result2.time = "0.2"
    result2.result = SCENARIO_PASS

    report = Report.new
    report.add_scenario_result(result1)
    report.add_scenario_result(result2)

    actual = @sut.format(report)
    expected = <<XML
<testsuite>
  <testcase name="201 POST /users" classname="" time="0.5" />
  <testcase name="400 POST /users" classname="" time="0.2" />
</testsuite>
XML
    expect_equivalent_xml(actual, expected)
  end

  def expect_equivalent_xml(actual_xml, expected_xml)
    actual = Nokogiri::XML(actual_xml)
    expected = Nokogiri::XML(expected_xml)
    expect(actual).to be_equivalent_to(expected)
  end
end

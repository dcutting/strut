require "spec_helper"

include Strut

describe ReportJunit do
  it 'returns an empty Junit report for an empty Strut report' do
    report = Report.new
    sut = ReportJunit.new
    actual = sut.format(report)
    expected = "<junit></junit>"
    expect(actual).to eq(expected)
  end
end
